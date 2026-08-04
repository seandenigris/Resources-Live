"
I adapt one Monticello definition parsed from a Tonel source.

I provide direct access to the corresponding live-image definition and detect class-shape and post-load hazards. I am a selection item, not an application unit.
"
Class {
	#name : 'RlTonelCodeChange',
	#superclass : 'RlCodeChange',
	#instVars : [
		'definition'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RlTonelCodeChange class >> codeSource: anRlTonelSource definition: aDefinition sourceOrder: anInteger [
	^ self new
		codeSource: anRlTonelSource;
		definition: aDefinition;
		sourceOrder: anInteger;
		yourself

]

{ #category : 'accessing' }
RlTonelCodeChange >> className [
	| answer |

	(definition respondsTo: #className) ifFalse: [
		^ '<unknown>' ].

	answer := definition className.
	answer ifNil: [ ^ '<unknown>' ].

	^ answer asString

]

{ #category : 'private - comparing' }
RlTonelCodeChange >> classShapeSignatureFor: aDefinition [
	^ {
		self
			definitionValueAt: #superclassName
			from: aDefinition.
		self
			definitionValueAt: #layoutClassName
			from: aDefinition.
		self
			definitionValueAt: #instanceVariablesString
			from: aDefinition.
		self
			definitionValueAt: #classVariablesString
			from: aDefinition.
		self
			definitionValueAt: #classInstanceVariablesString
			from: aDefinition }

]

{ #category : 'comparing' }
RlTonelCodeChange >> currentDefinition [
	| behavior aClass |

	self isMethodChange ifTrue: [
		behavior := self currentBehavior.
		behavior ifNil: [ ^ nil ].
		(behavior includesSelector: self methodSelector) ifFalse: [ ^ nil ].

		^ (behavior compiledMethodAt: self methodSelector)
			asMCMethodDefinition ].

	self isClassDefinition ifFalse: [ ^ nil ].

	aClass := self currentClass.
	aClass ifNil: [ ^ nil ].

	^ aClass asClassDefinition

]

{ #category : 'accessing' }
RlTonelCodeChange >> currentSource [
	| currentDefinition |

	currentDefinition := self currentDefinition.
	currentDefinition ifNil: [ ^ '' ].

	currentDefinition isMethodDefinition ifTrue: [
		^ currentDefinition source ].
	(currentDefinition respondsTo: #definitionString) ifTrue: [
		^ currentDefinition definitionString ].
	(currentDefinition respondsTo: #source) ifTrue: [
		^ currentDefinition source ].

	^ currentDefinition printString

]

{ #category : 'comparing' }
RlTonelCodeChange >> currentTypeDefinition [
	| aClass |

	aClass := self currentClass.
	aClass ifNil: [ ^ nil ].

	^ aClass asClassDefinition

]

{ #category : 'accessing' }
RlTonelCodeChange >> definition [
	^ definition

]

{ #category : 'accessing' }
RlTonelCodeChange >> definition: aDefinition [
	definition := aDefinition

]

{ #category : 'accessing' }
RlTonelCodeChange >> definitionPackageName [
	(definition respondsTo: #packageName) ifFalse: [ ^ nil ].
	definition packageName ifNil: [ ^ nil ].

	^ definition packageName asString

]

{ #category : 'accessing' }
RlTonelCodeChange >> definitionTagName [
	(definition respondsTo: #tagName) ifFalse: [ ^ nil ].
	definition tagName ifNil: [ ^ nil ].

	^ definition tagName asString

]

{ #category : 'private - comparing' }
RlTonelCodeChange >> definitionValueAt: aSelector from: aDefinition [
	(aDefinition respondsTo: aSelector) ifFalse: [ ^ nil ].

	^ aDefinition perform: aSelector

]

{ #category : 'testing' }
RlTonelCodeChange >> hasLoadTimeAction [
	self isInitializer ifTrue: [ ^ true ].

	^ self isExternalStructureFieldDefinition

]

{ #category : 'hazards' }
RlTonelCodeChange >> hazardMessages [
	| messages |

	messages := OrderedCollection new.

	self isClassShapeChange ifTrue: [
		messages add:
			'Loading this definition will reshape an existing class and may migrate existing instances.' ].

	self isInitializer ifTrue: [
		messages add:
			'Monticello will normally execute the class-side initialize method after the selected batch is loaded.' ].

	self isExternalStructureFieldDefinition ifTrue: [
		messages add:
			'Monticello may compile external-structure fields after loading this method.' ].

	^ messages

]

{ #category : 'accessing' }
RlTonelCodeChange >> incomingSource [
	self isMethodChange ifTrue: [
		^ definition source ].

	(definition respondsTo: #definitionString) ifTrue: [
		^ definition definitionString ].
	(definition respondsTo: #source) ifTrue: [
		^ definition source ].

	^ definition printString

]

{ #category : 'testing' }
RlTonelCodeChange >> isClassDefinition [
	definition isClassDefinition ifTrue: [ ^ true ].

	^ definition isTraitDefinition

]

{ #category : 'testing' }
RlTonelCodeChange >> isClassShapeChange [
	| currentDefinition |

	self isClassDefinition ifFalse: [ ^ false ].
	(definition isKindOf: MCClassDefinition) ifFalse: [ ^ false ].

	currentDefinition := self currentDefinition.
	currentDefinition ifNil: [ ^ false ].
	(currentDefinition isKindOf: MCClassDefinition) ifFalse: [ ^ true ].

	^ (self classShapeSignatureFor: currentDefinition)
		~= (self classShapeSignatureFor: definition)

]

{ #category : 'testing' }
RlTonelCodeChange >> isClassSide [
	definition isMethodDefinition ifFalse: [ ^ false ].

	^ definition classIsMeta

]

{ #category : 'testing' }
RlTonelCodeChange >> isExtensionMethod [
	self isMethodChange ifFalse: [ ^ false ].

	^ definition protocol asString beginsWith: '*'

]

{ #category : 'testing' }
RlTonelCodeChange >> isExternalStructureFieldDefinition [
	(definition respondsTo: #isExternalStructureFieldDefinition)
		ifFalse: [ ^ false ].

	^ [
		definition isExternalStructureFieldDefinition ]
			on: Error
			do: [ false ]

]

{ #category : 'testing' }
RlTonelCodeChange >> isInitializer [
	self isMethodChange ifFalse: [ ^ false ].
	self isClassSide ifFalse: [ ^ false ].

	^ self methodSelector = #initialize

]

{ #category : 'comparing' }
RlTonelCodeChange >> matchesDefinition: aDefinition [
	^ definition = aDefinition

]

{ #category : 'accessing' }
RlTonelCodeChange >> methodSelector [
	definition isMethodDefinition ifFalse: [ ^ nil ].

	^ definition selector

]

{ #category : 'accessing' }
RlTonelCodeChange >> newInstanceVariableNames [
	| currentDefinition incomingNames currentNames |

	self isClassDefinition ifFalse: [ ^ Set new ].
	(definition isKindOf: MCClassDefinition) ifFalse: [ ^ Set new ].

	incomingNames := definition instanceVariablesString substrings asSet.
	currentDefinition := self currentDefinition.
	currentDefinition ifNil: [ ^ incomingNames ].
	(currentDefinition isKindOf: MCClassDefinition)
		ifFalse: [ ^ incomingNames ].

	currentNames := currentDefinition instanceVariablesString substrings asSet.
	^ incomingNames difference: currentNames

]

{ #category : 'accessing' }
RlTonelCodeChange >> operationName [
	^ definition class name asString

]

{ #category : 'accessing' }
RlTonelCodeChange >> packageName [
	| answer protocolName |

	self isMethodChange ifTrue: [
		protocolName := definition protocol asString.
		(protocolName beginsWith: '*') ifTrue: [
			^ protocolName allButFirst ] ].

	(definition respondsTo: #packageName) ifTrue: [
		answer := definition packageName.
		answer ifNotNil: [ ^ answer asString ] ].

	^ self codeSource packageName

]

{ #category : 'testing' }
RlTonelCodeChange >> wouldChangeImage [
	| currentDefinition |

	currentDefinition := self currentDefinition.
	currentDefinition ifNil: [ ^ true ].

	^ currentDefinition ~= definition

]
