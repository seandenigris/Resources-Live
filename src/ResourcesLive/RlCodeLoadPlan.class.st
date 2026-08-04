"
I am a transient selective-load operation for one RlSmalltalkSource.

I own effective changes, selection state, the package/class/method presentation tree, validation, hazard confirmation, and creation of an immutable source materialization. The source resource remains free of operational state.

Application is not transactional. If loading fails, earlier changes may remain installed.
"
Class {
	#name : 'RlCodeLoadPlan',
	#superclass : 'Object',
	#instVars : [
		'codeSource',
		'changes',
		'selectedChanges',
		'changeTree'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RlCodeLoadPlan class >> on: anRlSmalltalkSource [
	^ self new
		codeSource: anRlSmalltalkSource;
		refresh;
		yourself

]

{ #category : 'hazards' }
RlCodeLoadPlan >> addUniqueMessage: aString to: aCollection [
	(aCollection includes: aString) ifTrue: [ ^ self ].

	aCollection add: aString

]

{ #category : 'selection' }
RlCodeLoadPlan >> allChangesAreSelected [
	self hasChanges ifFalse: [ ^ false ].

	^ selectedChanges size = changes size

]

{ #category : 'loading' }
RlCodeLoadPlan >> applySelectedChanges [
	| materialization errors |

	self selectedChanges isEmpty ifTrue: [ ^ false ].

	materialization := self materialization.
	errors := materialization validationErrors.
	errors ifNotEmpty: [
		self error:
			(self validationErrorTextFor: errors) ].

	(self confirmHazardsIfNecessaryFor: materialization)
		ifFalse: [ ^ false ].

	[
		materialization apply ]
			on: Error
			do: [ :error |
				self refresh.
				error pass ].

	self refresh.
	^ true

]

{ #category : 'selection' }
RlCodeLoadPlan >> changeIsSelected: anRlCodeChange [
	^ selectedChanges includes: anRlCodeChange

]

{ #category : 'gt - private' }
RlCodeLoadPlan >> changeRowFor: aNode checkboxMap: checkboxMap [
	| element |

	element := BlElement new
		layout: BlLinearLayout horizontal alignCenterLeft;
		constraintsDo: [ :constraints |
			constraints horizontal matchParent.
			constraints vertical fitContent ];
		margin: (BlInsets all: 3);
		yourself.

	aNode isSelectable ifTrue: [
		| checkbox |

		checkbox := BrCheckbox new
			aptitude:
				BrGlamorousCheckboxAptitude
					+
						(BrGlamorousWithExplicitTooltipAptitude
							text: aNode change selectionTooltip);
			checked: (self changeIsSelected: aNode change);
			whenCheckedDo: [
				self selectChange: aNode change ];
			whenUncheckedDo: [
				self deselectChange: aNode change ];
			margin: (BlInsets right: 8);
			yourself.

		checkboxMap
			at: aNode change
			put: checkbox.

		element addChild: checkbox ].

	(aNode kind = #class and: [ aNode isSelectable ]) ifFalse: [
		element addChild: aNode gtIconElement ].

	element addChild:
		(BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: aNode displayName asString asRopedText;
			padding:
				(BlInsets
					top: 0
					left: 6
					bottom: 0
					right: 3);
			constraintsDo: [ :constraints |
				constraints linear horizontal alignCenter ];
			yourself).

	^ element

]

{ #category : 'accessing' }
RlCodeLoadPlan >> changeTree [
	changeTree ifNotNil: [ ^ changeTree ].

	changeTree := RlCodeChangeTreeNode treeFor: self.
	^ changeTree

]

{ #category : 'accessing' }
RlCodeLoadPlan >> changes [
	^ changes

]

{ #category : 'accessing' }
RlCodeLoadPlan >> codeSource [
	^ codeSource

]

{ #category : 'accessing' }
RlCodeLoadPlan >> codeSource: anRlSmalltalkSource [
	codeSource := anRlSmalltalkSource

]

{ #category : 'hazards' }
RlCodeLoadPlan >> confirmHazardsIfNecessaryFor: aMaterialization [
	| messages |

	messages := self hazardMessagesForMaterialization: aMaterialization.
	messages ifEmpty: [ ^ true ].

	^ UIManager default confirm:
		(self hazardConfirmationTextFor: messages)

]

{ #category : 'selection' }
RlCodeLoadPlan >> deselectAllChanges [
	selectedChanges removeAll

]

{ #category : 'selection' }
RlCodeLoadPlan >> deselectChange: anRlCodeChange [
	selectedChanges remove: anRlCodeChange ifAbsent: [ ]

]

{ #category : 'gt - views' }
RlCodeLoadPlan >> gtChangesFor: aView context: aContext [
	<gtView>

	| checkboxMap |

	checkboxMap := IdentityDictionary new.

	^ aView tree
		title: 'Changes';
		priority: 1;
		items: [ self changeTree children ];
		children: #children;
		expandUpTo: 3;
		send: #objectToSpawn;
		stencil: [ :node |
			self
				changeRowFor: node
				checkboxMap: checkboxMap ];
		actionButtonLabel: 'Toggle all'
			action: [
				self toggleAllChanges.
				checkboxMap keysAndValuesDo: [ :change :checkbox |
					checkbox checked:
						(self changeIsSelected: change) ] ];
		actionButtonLabel: 'Inspect selected'
			action: [ :button |
				| materialization errors |

				self selectedChanges ifNotEmpty: [
					materialization := self materialization.
					errors := materialization validationErrors.
					errors
						ifEmpty: [
							button phlow spawnObject: materialization ]
						ifNotEmpty: [
							self error:
								(self validationErrorTextFor: errors) ] ] ];
		actionButtonLabel: 'Apply selected'
			action: [ :button |
				self applySelectedChanges ifTrue: [
					button phlow fireToolUpdateWish ] ];
		yourself

]

{ #category : 'testing' }
RlCodeLoadPlan >> hasChanges [
	^ self changes isNotEmpty

]

{ #category : 'hazards' }
RlCodeLoadPlan >> hazardConfirmationTextFor: messages [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Applying the selected changes has the following hazards:';
			cr.

		messages do: [ :message |
			stream
				nextPutAll: '- ';
				nextPutAll: message;
				cr ].

		stream
			cr;
			nextPutAll: 'Application is not transactional. If loading fails, the image may be partially modified.';
			cr;
			cr;
			nextPutAll: 'Proceed?' ]

]

{ #category : 'hazards' }
RlCodeLoadPlan >> hazardMessages [
	^ self hazardMessagesForMaterialization: self materialization

]

{ #category : 'hazards' }
RlCodeLoadPlan >> hazardMessagesForMaterialization: aMaterialization [
	| messages |

	messages := OrderedCollection new.

	self selectedChangesInSourceOrder do: [ :change |
		change hazardMessages do: [ :message |
			self
				addUniqueMessage: message
				to: messages ] ].

	aMaterialization hazardMessages do: [ :message |
		self
			addUniqueMessage: message
				to: messages ].

	^ messages

]

{ #category : 'accessing' }
RlCodeLoadPlan >> materialization [
	^ self codeSource codeSelectionMaterializationFor: self

]

{ #category : 'resolving' }
RlCodeLoadPlan >> packageNameForChange: anRlCodeChange [
	| packageName classDefinitionChange |

	packageName := anRlCodeChange packageName.
	packageName ifNotNil: [ ^ packageName ].

	classDefinitionChange := self changes
		detect: [ :change |
			change isClassDefinition
				and: [ change className = anRlCodeChange className ] ]
		ifNone: [ ^ '<unclassified>' ].

	^ classDefinitionChange packageName
		ifNil: [ '<unclassified>' ]

]

{ #category : 'refreshing' }
RlCodeLoadPlan >> refresh [
	changes := self codeSource loadableChanges select: #wouldChangeImage.
	selectedChanges := IdentitySet new
		addAll: changes;
		yourself.
	changeTree := nil

]

{ #category : 'selection' }
RlCodeLoadPlan >> selectAllChanges [
	selectedChanges
		removeAll;
		addAll: changes

]

{ #category : 'selection' }
RlCodeLoadPlan >> selectChange: anRlCodeChange [
	selectedChanges add: anRlCodeChange

]

{ #category : 'accessing' }
RlCodeLoadPlan >> selectedChanges [
	^ selectedChanges

]

{ #category : 'selection' }
RlCodeLoadPlan >> selectedChangesInSourceOrder [
	^ self selectedChanges asSortedCollection: #sourceOrder ascending

]

{ #category : 'selection' }
RlCodeLoadPlan >> toggleAllChanges [
	self allChangesAreSelected
		ifTrue: [ self deselectAllChanges ]
		ifFalse: [ self selectAllChanges ]

]

{ #category : 'validation' }
RlCodeLoadPlan >> validateSelectedChanges [
	| errors |

	errors := self validationErrors.
	errors ifEmpty: [ ^ self ].

	self error:
		(self validationErrorTextFor: errors)

]

{ #category : 'validation' }
RlCodeLoadPlan >> validationErrorTextFor: errors [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'The selected changes cannot be safely applied:';
			cr.

		errors do: [ :error |
			stream
				nextPutAll: '- ';
				nextPutAll: error;
				cr ] ]

]

{ #category : 'validation' }
RlCodeLoadPlan >> validationErrors [
	^ self materialization validationErrors

]
