"
I reconstruct selected CodeChunks into one valid chunk-format source artifact.

I preserve declaration order and metadata, escape chunk terminators through ChunkWriteStream, validate by reparsing with CodeImporter, and apply through CodeImporter>>evaluateString: rather than importing selected declarations directly.
"
Class {
	#name : 'RlChunkSelectionMaterialization',
	#superclass : 'RlCodeSelectionMaterialization',
	#instVars : [
		'sourceText',
		'parsedChunks'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'loading' }
RlChunkSelectionMaterialization >> apply [
	self assertValid.
	^ CodeImporter evaluateString: self sourceText

]

{ #category : 'private - writing' }
RlChunkSelectionMaterialization >> behaviorPreambleFor: aBehaviorOwnedChunk [
	^ String streamContents: [ :stream |
		stream nextPutAll: aBehaviorOwnedChunk behaviorName asString.
		aBehaviorOwnedChunk isMeta ifTrue: [
			stream nextPutAll: ' class' ] ]

]

{ #category : 'private - adapting' }
RlChunkSelectionMaterialization >> codeChunk: aCodeChunk answersTrueTo: aSelector [
	(aCodeChunk respondsTo: aSelector) ifFalse: [ ^ false ].

	^ aCodeChunk perform: aSelector

]

{ #category : 'accessing' }
RlChunkSelectionMaterialization >> parsedChunks [
	parsedChunks ifNotNil: [ ^ parsedChunks ].

	parsedChunks := CodeImporter
		chunksFromStream: self sourceText readStream.
	^ parsedChunks

]

{ #category : 'validation' }
RlChunkSelectionMaterialization >> preflightValidationErrors [
	| errors selectedClassNames |

	errors := OrderedCollection new.
	self hasSelection ifFalse: [
		errors add: 'No changes are selected.'.
		^ errors ].

	selectedClassNames := (self selectedChanges
		select: #isClassDefinition
		thenCollect: #className) asSet.

	self selectedChanges do: [ :change |
		(change isMethodChange
			and: [
				change currentClass isNil
					and: [
						(selectedClassNames includes: change className) not ] ])
			ifTrue: [
				errors add:
					'Method '
						, change displayName
						, ' targets missing class '
						, change className
						, ', whose definition is not selected.' ] ].

	^ errors

]

{ #category : 'validation' }
RlChunkSelectionMaterialization >> roundTripValidationErrors [
	| errors |

	errors := OrderedCollection new.

	self parsedChunks size = self selectedChanges size ifFalse: [
		errors add:
			'Chunk round trip changed the declaration count from '
				, self selectedChanges size asString
				, ' to '
				, self parsedChunks size asString.
		^ errors ].

	self selectedChanges
		with: self parsedChunks
		do: [ :change :parsedChunk |
			(change matchesCodeChunk: parsedChunk) ifFalse: [
				errors add:
					'Chunk round trip did not preserve '
						, change printString
						, '.' ] ].

	^ errors

]

{ #category : 'private - source' }
RlChunkSelectionMaterialization >> selectedOriginalChunks [
	| sourceChunks |

	sourceChunks := CodeImporter chunksFromFileNamed: self codeSource file.

	^ self selectedChanges collect: [ :change |
		| codeChunk |

		change sourceOrder > sourceChunks size ifTrue: [
			self error:
				'The file-out changed after this selection was created.' ].

		codeChunk := sourceChunks at: change sourceOrder.
		(change matchesCodeChunk: codeChunk) ifFalse: [
			self error:
				'The file-out changed after this selection was created.' ].

		codeChunk ]

]

{ #category : 'accessing' }
RlChunkSelectionMaterialization >> sourceArtifacts [
	^ {
		RlCodeSourceArtifact
			relativePath: 'selected.st'
			contents: self sourceText }

]

{ #category : 'accessing' }
RlChunkSelectionMaterialization >> sourceText [
	sourceText ifNotNil: [ ^ sourceText ].

	sourceText := String streamContents: [ :stringStream |
		| chunkStream |

		chunkStream := ChunkWriteStream on: stringStream.
		self selectedOriginalChunks do: [ :codeChunk |
			self
				writeCodeChunk: codeChunk
				on: chunkStream ] ].

	^ sourceText

]

{ #category : 'private - writing' }
RlChunkSelectionMaterialization >> writeCodeChunk: aCodeChunk on: aChunkWriteStream [
	(self
		codeChunk: aCodeChunk
		answersTrueTo: #isMethodDeclaration)
			ifTrue: [
				^ self
					writeMethodChunk: aCodeChunk
					on: aChunkWriteStream ].

	(self
		codeChunk: aCodeChunk
		answersTrueTo: #isClassCommentDeclaration)
			ifTrue: [
				^ self
					writeCommentChunk: aCodeChunk
					on: aChunkWriteStream ].

	(self
		codeChunk: aCodeChunk
		answersTrueTo: #isClassOrganizationDeclaration)
			ifTrue: [
				^ self
					writeOrganizationChunk: aCodeChunk
					on: aChunkWriteStream ].

	^ self
		writeSimpleChunk: aCodeChunk
		on: aChunkWriteStream

]

{ #category : 'private - writing' }
RlChunkSelectionMaterialization >> writeCommentChunk: aCommentChunk on: aChunkWriteStream [
	| preamble stamp |

	stamp := aCommentChunk stamp
		ifNil: [ '' ].

	preamble := String streamContents: [ :stream |
		stream
			nextPutAll:
				(self behaviorPreambleFor: aCommentChunk);
			nextPutAll: ' commentStamp: ';
			nextPutAll: stamp asString printString;
			nextPutAll: ' prior: 0' ].

	aChunkWriteStream
		cr;
		bang;
		nextPut: preamble;
		cr;
		nextPut:
			(aCommentChunk contents
				ifEmpty: [ String cr ])

]

{ #category : 'private - writing' }
RlChunkSelectionMaterialization >> writeMethodChunk: aMethodChunk on: aChunkWriteStream [
	| preamble metadata stamp |

	stamp := aMethodChunk stamp
		ifNil: [ '' ].
	metadata := aMethodChunk metadata
		ifNil: [ ' ' ].

	preamble := String streamContents: [ :stream |
		stream
			nextPutAll:
				(self behaviorPreambleFor: aMethodChunk);
			nextPutAll: ' methodsFor: ';
			nextPutAll: aMethodChunk protocol asString printString.

		stamp asString ifNotEmpty: [
			stream
				nextPutAll: ' stamp: ';
				nextPutAll: stamp asString printString ] ].

	aChunkWriteStream
		cr;
		cr;
		bang;
		nextPut: preamble;
		cr;
		nextPut: aMethodChunk contents;
		nextPut:
			(metadata ifEmpty: [ ' ' ])

]

{ #category : 'private - writing' }
RlChunkSelectionMaterialization >> writeOrganizationChunk: anOrganizationChunk on: aChunkWriteStream [
	| preamble metadata |

	metadata := anOrganizationChunk metadata
		ifNil: [ ' ' ].

	preamble := (self behaviorPreambleFor: anOrganizationChunk)
		, ' reorganize'.

	aChunkWriteStream
		cr;
		bang;
		nextPut: preamble;
		cr;
		nextPut: anOrganizationChunk contents;
		nextPut:
			(metadata ifEmpty: [ ' ' ])

]

{ #category : 'private - writing' }
RlChunkSelectionMaterialization >> writeSimpleChunk: aCodeChunk on: aChunkWriteStream [
	aChunkWriteStream
		cr;
		nextPut: aCodeChunk contents

]
