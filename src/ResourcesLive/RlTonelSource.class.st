"
I represent one Tonel source file.

TonelParser answers Monticello definitions for the class, trait, or extension entity represented by my file. A selected subset is reconstructed as a valid in-memory Tonel package, parsed again through TonelReader, verified, and then applied as one strict subset patch.
"
Class {
	#name : 'RlTonelSource',
	#superclass : 'RlSmalltalkSource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'testing' }
RlTonelSource class >> isClassFor: aFileReference [
	aFileReference extension asLowercase = 'st' ifFalse: [ ^ false ].

	^ [
		aFileReference readStreamDo: [ :stream |
			(TonelParser parseStream: stream) isNotEmpty ] ]
				on: Error
				do: [ false ]

]

{ #category : 'changes' }
RlTonelSource >> codeSelectionMaterializationFor: anRlCodeLoadPlan [
	^ RlTonelSelectionMaterialization on: anRlCodeLoadPlan

]

{ #category : 'private - parsing' }
RlTonelSource >> definitions [
	^ self file readStreamDo: [ :stream |
		TonelParser parseStream: stream ]

]

{ #category : 'changes' }
RlTonelSource >> loadableChanges [
	^ self definitions
		withIndexCollect: [ :definition :sourceOrder |
			RlTonelCodeChange
				codeSource: self
				definition: definition
				sourceOrder: sourceOrder ]

]

{ #category : 'accessing' }
RlTonelSource >> packageName [
	^ self file parent basename

]
