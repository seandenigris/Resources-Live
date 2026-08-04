"
I represent a classic Smalltalk chunk-format file-out.

I use CodeImporter to parse my file into CodeChunk declarations without evaluating them. A selected subset is reconstructed as a valid chunk-format artifact and then loaded through CodeImporter as an ordinary file-in.
"
Class {
	#name : 'RlFileOut',
	#superclass : 'RlSmalltalkSource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'testing' }
RlFileOut class >> isClassFor: aFileReference [
	aFileReference extension asLowercase = 'st' ifFalse: [ ^ false ].
	(RlTonelSource isClassFor: aFileReference) ifTrue: [ ^ false ].

	^ true

]

{ #category : 'changes' }
RlFileOut >> codeSelectionMaterializationFor: anRlCodeLoadPlan [
	^ RlChunkSelectionMaterialization on: anRlCodeLoadPlan

]

{ #category : 'changes' }
RlFileOut >> loadableChanges [
	^ (CodeImporter chunksFromFileNamed: self file)
		withIndexCollect: [ :codeChunk :sourceOrder |
			RlChunkCodeChange
				codeSource: self
				codeChunk: codeChunk
				sourceOrder: sourceOrder ]

]
