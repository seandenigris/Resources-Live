"
I provide the format-independent review protocol for one incoming source change.

I know how to compare and display myself and how to report hazards. I do not apply myself. Selected changes are first reconstructed into a valid source artifact by an RlCodeSelectionMaterialization.
"
Class {
	#name : 'RlCodeChange',
	#superclass : 'Object',
	#instVars : [
		'codeSource',
		'sourceOrder'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'accessing' }
RlCodeChange >> className [
	self subclassResponsibility

]

{ #category : 'accessing' }
RlCodeChange >> codeSource [
	^ codeSource

]

{ #category : 'accessing' }
RlCodeChange >> codeSource: anRlSmalltalkSource [
	codeSource := anRlSmalltalkSource

]

{ #category : 'accessing' }
RlCodeChange >> currentBehavior [
	| aClass |

	aClass := self currentClass.
	aClass ifNil: [ ^ nil ].

	^ self isClassSide
		ifTrue: [ aClass classSide ]
		ifFalse: [ aClass instanceSide ]

]

{ #category : 'accessing' }
RlCodeChange >> currentClass [
	self className = '<unknown>' ifTrue: [ ^ nil ].

	^ Smalltalk globals
		at: self className asSymbol
		ifAbsent: [ nil ]

]

{ #category : 'accessing' }
RlCodeChange >> currentSource [
	| behavior selector aClass |

	self isMethodChange ifTrue: [
		behavior := self currentBehavior.
		behavior ifNil: [ ^ '' ].

		selector := self methodSelector.
		(behavior includesSelector: selector) ifFalse: [ ^ '' ].

		^ behavior sourceCodeAt: selector ].

	self isClassDefinition ifFalse: [ ^ '' ].

	aClass := self currentClass.
	aClass ifNil: [ ^ '' ].

	^ aClass definitionString

]

{ #category : 'accessing' }
RlCodeChange >> displayName [
	self isMethodChange ifFalse: [
		self isClassDefinition ifTrue: [ ^ self className ].
		^ self operationName ].

	self isClassSide ifFalse: [
		^ self methodSelector asString ].

	^ self methodSelector asString , ' (class)'

]

{ #category : 'gt - views' }
RlCodeChange >> gtCurrentFor: aView [
	<gtView>

	self currentSource ifEmpty: [ ^ aView empty ].

	^ aView text
		title: 'Current';
		priority: 2;
		text: [ self currentSource ];
		styler: [ BrSmalltalkSyntaxStyler new ];
		yourself

]

{ #category : 'gt - views' }
RlCodeChange >> gtIncomingFor: aView [
	<gtView>

	^ aView text
		title: 'Incoming';
		priority: 1;
		text: [ self incomingSource ];
		styler: [ BrSmalltalkSyntaxStyler new ];
		yourself

]

{ #category : 'testing' }
RlCodeChange >> hasHazards [
	^ self hazardMessages isNotEmpty

]

{ #category : 'testing' }
RlCodeChange >> hasLoadTimeAction [
	^ false

]

{ #category : 'hazards' }
RlCodeChange >> hazardLabelSuffix [
	self isClassShapeChange ifTrue: [ ^ ' [shape]' ].
	self hasLoadTimeAction ifTrue: [ ^ ' [runs code]' ].
	self hasHazards ifTrue: [ ^ ' [warning]' ].

	^ ''

]

{ #category : 'hazards' }
RlCodeChange >> hazardMessages [
	^ #()

]

{ #category : 'accessing' }
RlCodeChange >> incomingSource [
	self subclassResponsibility

]

{ #category : 'testing' }
RlCodeChange >> isClassDefinition [
	self subclassResponsibility

]

{ #category : 'testing' }
RlCodeChange >> isClassShapeChange [
	^ false

]

{ #category : 'testing' }
RlCodeChange >> isClassSide [
	self subclassResponsibility

]

{ #category : 'testing' }
RlCodeChange >> isInitializer [
	^ false

]

{ #category : 'testing' }
RlCodeChange >> isMethodChange [
	^ self methodSelector isNotNil

]

{ #category : 'accessing' }
RlCodeChange >> methodSelector [
	self subclassResponsibility

]

{ #category : 'comparing' }
RlCodeChange >> normalizedSource: aString [
	| normalized |

	normalized := String streamContents: [ :stream |
		| previousWasSeparator |

		previousWasSeparator := false.
		aString do: [ :character |
			character isSeparator
				ifTrue: [
					previousWasSeparator ifFalse: [
						stream space.
						previousWasSeparator := true ] ]
				ifFalse: [
					stream nextPut: character.
					previousWasSeparator := false ] ] ].

	^ normalized trimBoth

]

{ #category : 'accessing' }
RlCodeChange >> operationName [
	^ self class name

]

{ #category : 'accessing' }
RlCodeChange >> packageName [
	self subclassResponsibility

]

{ #category : 'printing' }
RlCodeChange >> printOn: aStream [
	aStream
		nextPutAll:
			(self packageName
				ifNil: [ '<unclassified>' ]);
		nextPutAll: ' / ';
		nextPutAll: self className;
		nextPutAll: ' / ';
		nextPutAll: self displayName

]

{ #category : 'hazards' }
RlCodeChange >> selectionTooltip [
	self hasHazards ifFalse: [ ^ 'Select for loading' ].

	^ String streamContents: [ :stream |
		| first |

		stream nextPutAll: 'Select for loading. '.
		first := true.

		self hazardMessages do: [ :message |
			first
				ifTrue: [ first := false ]
				ifFalse: [ stream space ].
			stream nextPutAll: message ] ]

]

{ #category : 'accessing' }
RlCodeChange >> sourceOrder [
	^ sourceOrder

]

{ #category : 'accessing' }
RlCodeChange >> sourceOrder: anInteger [
	sourceOrder := anInteger

]

{ #category : 'accessing' }
RlCodeChange >> treeDisplayName [
	^ self displayName , self hazardLabelSuffix

]

{ #category : 'testing' }
RlCodeChange >> wouldChangeImage [
	| existingSource |

	(self isMethodChange or: [ self isClassDefinition ]) ifFalse: [
		^ true ].

	existingSource := self currentSource.
	existingSource ifEmpty: [ ^ true ].

	self isMethodChange ifTrue: [
		^ existingSource withInternalLineEndings
			~= self incomingSource withInternalLineEndings ].

	^ (self normalizedSource: existingSource)
		~= (self normalizedSource: self incomingSource)

]
