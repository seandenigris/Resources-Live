"
I reconstruct selected Tonel definitions into a valid in-memory Tonel package.

For checked regular methods whose class definition is unchecked, I include the current live class or trait definition only as serialization context. After TonelWriter and TonelReader round-trip the package, contextual and organization definitions are removed from the effective delta. The selected recovered definitions are then applied as one strict Monticello subset patch.
"
Class {
	#name : 'RlTonelSelectionMaterialization',
	#superclass : 'RlCodeSelectionMaterialization',
	#instVars : [
		'fileSystem',
		'packageName',
		'materializedDefinitions',
		'parsedDefinitions',
		'contextDefinitions',
		'baseDefinitionsByChange'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'hazards' }
RlTonelSelectionMaterialization >> addUncheckedShapeWarningsFor: classChange addedVariables: addedVariables to: messages [
	self selectedChanges do: [ :methodChange |
		| mentionedVariables |

		methodChange isMethodChange ifTrue: [
			methodChange className = classChange className ifTrue: [
				mentionedVariables := (self
					identifierTokensIn: methodChange incomingSource)
						intersection: addedVariables.

				mentionedVariables ifNotEmpty: [
					messages add:
						'The checked method '
							, methodChange displayName
							, ' mentions new instance variable(s) '
							, (self commaSeparated:
								mentionedVariables asSortedCollection)
							, ', but the corresponding class definition is unchecked.' ] ] ] ]

]

{ #category : 'loading' }
RlTonelSelectionMaterialization >> apply [
	| targetDefinitions baseDefinitions patch loader |

	self assertValid.
	targetDefinitions := self recoveredSelectedDefinitions.
	baseDefinitions := (self selectedChanges
		collect: [ :change |
			self baseDefinitionsByChange at: change ])
				reject: #isNil.

	patch := MCPatch
		fromBase:
			(MCSnapshot
				fromDefinitions: baseDefinitions)
		target:
			(MCSnapshot
				fromDefinitions: targetDefinitions).

	loader := MCPackageLoader new.
	loader beStrict.
	patch applyTo: loader.
	loader load

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> baseDefinitionsByChange [
	baseDefinitionsByChange ifNotNil: [
		^ baseDefinitionsByChange ].

	baseDefinitionsByChange := IdentityDictionary new.
	self selectedChanges do: [ :change |
		baseDefinitionsByChange
			at: change
			put: change currentDefinition ].

	^ baseDefinitionsByChange

]

{ #category : 'printing' }
RlTonelSelectionMaterialization >> commaSeparated: aCollection [
	^ String streamContents: [ :stream |
		| first |

		first := true.
		aCollection do: [ :each |
			first
				ifTrue: [ first := false ]
				ifFalse: [ stream nextPutAll: ', ' ].
			stream nextPutAll: each asString ] ]

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> contextDefinitions [
	| selectedClassNames contextByClass |

	contextDefinitions ifNotNil: [ ^ contextDefinitions ].

	selectedClassNames := self selectedDefinitionClassNames.
	contextByClass := Dictionary new.

	self selectedChanges do: [ :change |
		(change isMethodChange
			and: [ change isExtensionMethod not ])
			ifTrue: [
				(selectedClassNames includes: change className)
					ifFalse: [
						contextByClass
							at: change className
							ifAbsentPut: [
								change currentTypeDefinition ] ] ] ].

	contextDefinitions := contextByClass values asArray.
	^ contextDefinitions

]

{ #category : 'validation' }
RlTonelSelectionMaterialization >> currentImageValidationErrors [
	| errors |

	errors := OrderedCollection new.

	self baseDefinitionsByChange keysAndValuesDo: [ :change :expected |
		| actual |

		actual := change currentDefinition.
		expected = actual ifFalse: [
			errors add:
				'The live definition of '
					, change displayName
					, ' changed after this source materialization was created.' ] ].

	self contextDefinitions do: [ :expected |
		| aClass actual |

		aClass := Smalltalk globals
			at: expected className
			ifAbsent: [ nil ].
		actual := aClass
			ifNil: [ nil ]
			ifNotNil: [ aClass asClassDefinition ].

		expected = actual ifFalse: [
			errors add:
				'The live class context for '
					, expected className asString
					, ' changed after this source materialization was created.' ] ].

	^ errors

]

{ #category : 'validation' }
RlTonelSelectionMaterialization >> definitionKindValidationErrors [
	| errors |

	errors := OrderedCollection new.

	(self selectedChanges select: #isClassDefinition) do: [ :change |
		| currentDefinition |

		currentDefinition := change currentDefinition.
		currentDefinition ifNotNil: [
			currentDefinition class = change definition class ifFalse: [
				errors add:
					'Changing '
						, change className
						, ' from '
						, currentDefinition class name
						, ' to '
						, change definition class name
						, ' is not supported by selective loading.' ] ] ].

	^ errors

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> definitionsWithoutOrganization [
	^ self contextDefinitions
		, (self selectedChanges collect: #definition)

]

{ #category : 'validation' }
RlTonelSelectionMaterialization >> dependencyValidationErrors [
	| definitions sorter missingRequirements |

	definitions := self selectedChanges collect: #definition.
	sorter := MCDependencySorter items: definitions.
	sorter addExternalProvisions: Smalltalk globals keys.
	missingRequirements := sorter externalRequirements.

	missingRequirements ifEmpty: [ ^ #() ].

	^ {
		'Missing required classes or traits: '
			, (self commaSeparated:
				missingRequirements asSortedCollection) }

]

{ #category : 'private - source' }
RlTonelSelectionMaterialization >> fileSystem [
	fileSystem ifNotNil: [ ^ fileSystem ].

	fileSystem := FileSystem memory.
	(TonelWriter on: fileSystem root)
		writeSnapshot:
			(MCSnapshot
				fromDefinitions: self materializedDefinitions).

	^ fileSystem

]

{ #category : 'hazards' }
RlTonelSelectionMaterialization >> hazardMessages [
	| messages |

	messages := OrderedCollection new.

	self plan changes do: [ :classChange |
		| addedVariables |

		classChange isClassShapeChange ifTrue: [
			(self plan changeIsSelected: classChange) ifFalse: [
				addedVariables := classChange newInstanceVariableNames.
				addedVariables ifNotEmpty: [
					self
						addUncheckedShapeWarningsFor: classChange
						addedVariables: addedVariables
						to: messages ] ] ] ].

	^ messages

]

{ #category : 'private - parsing' }
RlTonelSelectionMaterialization >> identifierTokensIn: aString [
	| tokens tokenStart |

	tokens := Set new.
	tokenStart := nil.

	1 to: aString size do: [ :index |
		| character |

		character := aString at: index.
		(character isAlphaNumeric or: [ character = $_ ])
			ifTrue: [
				tokenStart ifNil: [
					tokenStart := index ] ]
			ifFalse: [
				tokenStart ifNotNil: [
					tokens add:
						(aString
							copyFrom: tokenStart
							to: index - 1).
					tokenStart := nil ] ] ].

	tokenStart ifNotNil: [
		tokens add:
			(aString
				copyFrom: tokenStart
				to: aString size) ].

	^ tokens

]

{ #category : 'validation' }
RlTonelSelectionMaterialization >> initializerValidationErrors [
	| errors |

	errors := OrderedCollection new.

	(self selectedChanges select: #isInitializer) do: [ :initializer |
		| unselected |

		unselected := self plan changes select: [ :change |
			change className = initializer className
				and: [
					(self plan changeIsSelected: change) not ] ].

		unselected ifNotEmpty: [
			errors add:
				'The selected initializer for '
					, initializer className
					, ' would run while these incoming changes remain unchecked: '
					, (self commaSeparated:
						(unselected collect: #displayName))
					, '. Select all incoming changes for that class or deselect initialize.' ] ].

	^ errors

]

{ #category : 'accessing' }
RlTonelSelectionMaterialization >> materializedDefinitions [
	materializedDefinitions ifNotNil: [
		^ materializedDefinitions ].

	materializedDefinitions := {
		self organizationDefinition }
			, self definitionsWithoutOrganization.

	^ materializedDefinitions

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> organizationDefinition [
	| tagNames |

	tagNames := (self definitionsWithoutOrganization
		collect: [ :definition |
			(definition respondsTo: #tagName)
				ifTrue: [ definition tagName ]
				ifFalse: [ nil ] ])
					reject: #isNil.

	^ MCOrganizationDefinition
		packageName: self packageName
		tagNames: tagNames asSet

]

{ #category : 'accessing' }
RlTonelSelectionMaterialization >> packageName [
	packageName ifNotNil: [ ^ packageName ].

	packageName := self codeSource packageName.
	^ packageName

]

{ #category : 'accessing' }
RlTonelSelectionMaterialization >> parsedDefinitions [
	| reader |

	parsedDefinitions ifNotNil: [ ^ parsedDefinitions ].

	reader := TonelReader
		on: self fileSystem root
		fileName: self packageName.
	reader loadDefinitions.
	parsedDefinitions := reader definitions.

	^ parsedDefinitions

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> parsedDefinitionsWithoutOrganization [
	^ self parsedDefinitions reject: #isOrganizationDefinition

]

{ #category : 'validation' }
RlTonelSelectionMaterialization >> preflightValidationErrors [
	| errors selectedDefinitionClassNames |

	errors := OrderedCollection new.
	self hasSelection ifFalse: [
		errors add: 'No changes are selected.'.
		^ errors ].

	self baseDefinitionsByChange.
	selectedDefinitionClassNames := (self selectedChanges
		select: #isClassDefinition
		thenCollect: #className) asSet.

	self selectedChanges do: [ :change |
		change isClassDefinition ifTrue: [
			change definitionPackageName ifNotNil: [ :definitionPackage |
				definitionPackage = self packageName ifFalse: [
					errors add:
						'Definition '
							, change className
							, ' belongs to package '
							, definitionPackage
							, ', but the source artifact belongs to '
							, self packageName
							, '.' ] ] ].

		(change isMethodChange
			and: [ change isExtensionMethod ])
			ifTrue: [
				(selectedDefinitionClassNames includes: change className)
					ifTrue: [
						errors add:
							'The selected extension method '
								, change displayName
								, ' targets a class whose definition is also selected. Tonel would serialize that method twice.' ] ].

		(change isMethodChange
			and: [ change isExtensionMethod not ])
			ifTrue: [
				(selectedDefinitionClassNames includes: change className)
					ifFalse: [
						change currentTypeDefinition
							ifNil: [
								errors add:
									'Regular method '
										, change displayName
										, ' targets missing class '
										, change className
										, ', whose definition is not selected.' ]
							ifNotNil: [ :currentDefinition |
								currentDefinition packageName asString
									= self packageName
									ifFalse: [
										errors add:
											'Regular method '
												, change displayName
												, ' requires current class context from package '
												, currentDefinition packageName asString
												, ', but the Tonel artifact belongs to '
												, self packageName
												, '.' ] ] ] ] ].

	errors addAll: self dependencyValidationErrors.
	errors addAll: self initializerValidationErrors.
	errors addAll: self definitionKindValidationErrors.

	^ errors

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> recoveredSelectedDefinitions [
	| parsed |

	parsed := self parsedDefinitionsWithoutOrganization asOrderedCollection.

	^ self selectedChanges collect: [ :change |
		parsed
			detect: [ :definition |
				definition = change definition ]
			ifNone: [
				self error:
					'The materialized Tonel source no longer contains selected definition '
						, change displayName
						, '.' ] ]

]

{ #category : 'private - source' }
RlTonelSelectionMaterialization >> relativePathFor: aFileReference [
	| pathString |

	pathString := aFileReference pathString.
	(pathString beginsWith: '/') ifTrue: [
		^ pathString allButFirst ].

	^ pathString

]

{ #category : 'validation' }
RlTonelSelectionMaterialization >> roundTripValidationErrors [
	| errors expected actual |

	errors := OrderedCollection new.
	errors addAll: self currentImageValidationErrors.
	errors ifNotEmpty: [ ^ errors ].

	expected := self definitionsWithoutOrganization
		asSortedCollection: #sortKey ascending.
	actual := self parsedDefinitionsWithoutOrganization
		asSortedCollection: #sortKey ascending.

	expected size = actual size ifFalse: [
		errors add:
			'Tonel round trip changed the definition count from '
				, expected size asString
				, ' to '
				, actual size asString.
		^ errors ].

	expected
		with: actual
		do: [ :expectedDefinition :actualDefinition |
			expectedDefinition = actualDefinition ifFalse: [
				errors add:
					'Tonel round trip changed definition '
						, expectedDefinition summary
						, '.' ] ].

	self selectedChanges do: [ :change |
		(actual anySatisfy: [ :definition |
			definition = change definition ]) ifFalse: [
				errors add:
					'Tonel round trip lost selected definition '
						, change displayName
						, '.' ] ].

	^ errors

]

{ #category : 'private - definitions' }
RlTonelSelectionMaterialization >> selectedDefinitionClassNames [
	^ (self selectedChanges
		select: #isClassDefinition
		thenCollect: #className) asSet

]

{ #category : 'accessing' }
RlTonelSelectionMaterialization >> sourceArtifacts [
	^ (self fileSystem root allFiles
		asSortedCollection: #pathString ascending)
			collect: [ :file |
				RlCodeSourceArtifact
					relativePath:
						(self relativePathFor: file)
					contents: file contents ]

]
