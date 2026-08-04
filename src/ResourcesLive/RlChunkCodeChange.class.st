"
I adapt one CodeChunk declaration from a classic chunk-format file-out.

I capture preview metadata without retaining a stream. I treat chunk-type testing as an optional protocol because GT and Pharo CodeImport versions differ in which default testing messages their chunk hierarchies provide. The selection materialization reparses the original, verifies selected declarations, reconstructs valid chunk-format text, parses that text again, and finally loads it through CodeImporter.
"
Class {
	#name : 'RlChunkCodeChange',
	#superclass : 'RlCodeChange',
	#instVars : [
		'incomingSource',
		'recordType',
		'className',
		'methodSelector',
		'classSide',
		'protocol',
		'classDefinition'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RlChunkCodeChange class >> codeSource: anRlFileOut codeChunk: aCodeChunk sourceOrder: anInteger [
	^ self new
		codeSource: anRlFileOut;
		sourceOrder: anInteger;
		initializeFromCodeChunk: aCodeChunk;
		yourself

]

{ #category : 'private - adapting' }
RlChunkCodeChange >> classDefinitionFromCodeChunk: aCodeChunk [
	| sourceText |

	(self
		codeChunk: aCodeChunk
		answersTrueTo: #isClassDeclaration)
			ifTrue: [ ^ true ].

	(self
		codeChunk: aCodeChunk
		answersTrueTo: #isClassAdditionChunk)
			ifTrue: [ ^ true ].

	sourceText := incomingSource trimBoth.
	(sourceText beginsWith: 'Class {') ifTrue: [ ^ true ].
	(sourceText beginsWith: 'Trait {') ifTrue: [ ^ true ].

	^ #(
		'subclass:'
		'variableSubclass:'
		'variableByteSubclass:'
		'variableWordSubclass:'
		'variableDoubleByteSubclass:'
		'variableDoubleWordSubclass:'
		'weakSubclass:'
		'ephemeronSubclass:'
		'compiledMethodSubclass:'
		'immediateSubclass:')
			anySatisfy: [ :marker |
				sourceText includesSubstring: marker ]

]

{ #category : 'accessing' }
RlChunkCodeChange >> className [
	^ className

]

{ #category : 'private - adapting' }
RlChunkCodeChange >> classNameFromCodeChunk: aCodeChunk [
	| answer |

	(aCodeChunk respondsTo: #behaviorName) ifTrue: [
		answer := aCodeChunk behaviorName.
		answer ifNotNil: [
			^ self nonMetaClassNameFrom: answer asString ] ].

	self isClassDefinition ifTrue: [
		^ self classNameFromDefinition ].

	^ '<unknown>'

]

{ #category : 'private - parsing' }
RlChunkCodeChange >> classNameFromDefinition [
	| answer |

	answer := self quotedValueFollowing: '#name :'.
	answer ifNotNil: [ ^ answer ].

	#(
		'subclass: #'
		'variableSubclass: #'
		'variableByteSubclass: #'
		'variableWordSubclass: #'
		'variableDoubleByteSubclass: #'
		'variableDoubleWordSubclass: #'
		'weakSubclass: #'
		'ephemeronSubclass: #'
		'compiledMethodSubclass: #'
		'immediateSubclass: #')
			do: [ :marker |
				answer := self tokenFollowing: marker.
				answer ifNotNil: [ ^ answer ] ].

	^ '<unknown>'

]

{ #category : 'private - adapting' }
RlChunkCodeChange >> classSideFromCodeChunk: aCodeChunk [
	(aCodeChunk respondsTo: #isMeta) ifFalse: [ ^ false ].

	^ aCodeChunk isMeta

]

{ #category : 'private - adapting' }
RlChunkCodeChange >> codeChunk: aCodeChunk answersTrueTo: aSelector [
	(aCodeChunk respondsTo: aSelector) ifFalse: [ ^ false ].

	^ aCodeChunk perform: aSelector

]

{ #category : 'private - parsing' }
RlChunkCodeChange >> extensionPackageName [
	protocol ifNil: [ ^ nil ].
	protocol isString ifFalse: [ ^ nil ].
	(protocol beginsWith: '*') ifFalse: [ ^ nil ].

	^ protocol allButFirst

]

{ #category : 'testing' }
RlChunkCodeChange >> hasLoadTimeAction [
	^ self isDoItChunk

]

{ #category : 'hazards' }
RlChunkCodeChange >> hazardMessages [
	| messages |

	messages := OrderedCollection new.

	self isClassShapeChange ifTrue: [
		messages add:
			'Loading this class definition may reshape an existing class and migrate its instances.' ].

	self isDoItChunk ifTrue: [
		messages add:
			'This chunk evaluates code and may perform initialization, registration, migration, or other arbitrary side effects.' ].

	^ messages

]

{ #category : 'accessing' }
RlChunkCodeChange >> incomingSource [
	^ incomingSource

]

{ #category : 'initialization' }
RlChunkCodeChange >> initializeFromCodeChunk: aCodeChunk [
	incomingSource := aCodeChunk contents asString.
	recordType := aCodeChunk class name.
	classSide := self classSideFromCodeChunk: aCodeChunk.
	protocol := self protocolFromCodeChunk: aCodeChunk.
	methodSelector := self methodSelectorFromCodeChunk: aCodeChunk.
	classDefinition := self classDefinitionFromCodeChunk: aCodeChunk.
	className := self classNameFromCodeChunk: aCodeChunk

]

{ #category : 'testing' }
RlChunkCodeChange >> isClassDefinition [
	^ classDefinition

]

{ #category : 'testing' }
RlChunkCodeChange >> isClassShapeChange [
	self isClassDefinition ifFalse: [ ^ false ].

	^ self currentClass isNotNil

]

{ #category : 'testing' }
RlChunkCodeChange >> isClassSide [
	^ classSide

]

{ #category : 'testing' }
RlChunkCodeChange >> isDoItChunk [
	^ recordType asString includesSubstring: 'DoItChunk'

]

{ #category : 'comparing' }
RlChunkCodeChange >> matchesCodeChunk: aCodeChunk [
	incomingSource = aCodeChunk contents asString ifFalse: [ ^ false ].
	recordType = aCodeChunk class name ifFalse: [ ^ false ].
	classSide = (self classSideFromCodeChunk: aCodeChunk) ifFalse: [ ^ false ].
	protocol = (self protocolFromCodeChunk: aCodeChunk) ifFalse: [ ^ false ].
	methodSelector = (self methodSelectorFromCodeChunk: aCodeChunk) ifFalse: [ ^ false ].
	classDefinition = (self classDefinitionFromCodeChunk: aCodeChunk) ifFalse: [ ^ false ].

	^ className = (self classNameFromCodeChunk: aCodeChunk)

]

{ #category : 'accessing' }
RlChunkCodeChange >> methodSelector [
	^ methodSelector

]

{ #category : 'private - adapting' }
RlChunkCodeChange >> methodSelectorFromCodeChunk: aCodeChunk [
	(self
		codeChunk: aCodeChunk
		answersTrueTo: #isMethodDeclaration)
			ifFalse: [ ^ nil ].

	(aCodeChunk respondsTo: #methodSelector) ifTrue: [
		^ aCodeChunk methodSelector ].

	^ [
		OCParser parseMethodPattern: incomingSource ]
			on: Error
			do: [ nil ]

]

{ #category : 'private - parsing' }
RlChunkCodeChange >> nonMetaClassNameFrom: aString [
	(aString endsWith: ' class') ifTrue: [
		^ aString allButLast: ' class' size ].

	^ aString

]

{ #category : 'accessing' }
RlChunkCodeChange >> operationName [
	^ recordType asString

]

{ #category : 'accessing' }
RlChunkCodeChange >> packageName [
	| aClass extensionPackage |

	extensionPackage := self extensionPackageName.
	extensionPackage ifNotNil: [ ^ extensionPackage ].

	aClass := self currentClass.
	aClass ifNotNil: [ ^ aClass package name ].

	^ self packageNameFromDefinition

]

{ #category : 'private - parsing' }
RlChunkCodeChange >> packageNameFromDefinition [
	| answer |

	#('#package :' 'package:' 'category:')
		do: [ :marker |
			answer := self quotedValueFollowing: marker.
			answer ifNotNil: [ ^ answer ] ].

	^ nil

]

{ #category : 'private - adapting' }
RlChunkCodeChange >> protocolFromCodeChunk: aCodeChunk [
	(aCodeChunk respondsTo: #protocol) ifFalse: [ ^ nil ].

	^ aCodeChunk protocol

]

{ #category : 'private - parsing' }
RlChunkCodeChange >> quotedValueFollowing: aMarker [
	| markerStart openingQuote closingQuote |

	markerStart := incomingSource
		findString: aMarker
		startingAt: 1.
	markerStart = 0 ifTrue: [ ^ nil ].

	openingQuote := incomingSource
		indexOf: $'
		startingAt: markerStart + aMarker size.
	openingQuote = 0 ifTrue: [ ^ nil ].

	closingQuote := incomingSource
		indexOf: $'
		startingAt: openingQuote + 1.
	closingQuote = 0 ifTrue: [ ^ nil ].

	^ incomingSource
		copyFrom: openingQuote + 1
		to: closingQuote - 1

]

{ #category : 'private - parsing' }
RlChunkCodeChange >> tokenFollowing: aMarker [
	| markerStart tokenStart tokenEnd |

	markerStart := incomingSource
		findString: aMarker
		startingAt: 1.
	markerStart = 0 ifTrue: [ ^ nil ].

	tokenStart := markerStart + aMarker size.
	tokenEnd := tokenStart.

	[
		tokenEnd <= incomingSource size
			and: [
				(incomingSource at: tokenEnd) isAlphaNumeric
					or: [ (incomingSource at: tokenEnd) = $_ ] ] ]
		whileTrue: [
			tokenEnd := tokenEnd + 1 ].

	tokenEnd = tokenStart ifTrue: [ ^ nil ].

	^ incomingSource
		copyFrom: tokenStart
		to: tokenEnd - 1

]

{ #category : 'testing' }
RlChunkCodeChange >> wouldChangeImage [
	| behavior existingSource currentProtocol sourceWouldChange |

	self isMethodChange ifFalse: [
		^ super wouldChangeImage ].

	behavior := self currentBehavior.
	behavior ifNil: [ ^ true ].
	(behavior includesSelector: self methodSelector) ifFalse: [ ^ true ].

	existingSource := behavior sourceCodeAt: self methodSelector.
	sourceWouldChange := existingSource withInternalLineEndings
		~= self incomingSource withInternalLineEndings.
	sourceWouldChange ifTrue: [ ^ true ].

	protocol ifNil: [ ^ false ].
	currentProtocol := behavior protocolOfSelector: self methodSelector.
	currentProtocol ifNil: [ ^ true ].

	^ currentProtocol name asString ~= protocol asString

]
