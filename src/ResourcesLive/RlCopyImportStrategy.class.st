"
I copy the resource's file into the library; leaving a copy in its original location.

"
Class {
	#name : 'RlCopyImportStrategy',
	#superclass : 'RlInPlaceImportStrategy',
	#category : 'ResourcesLive-Importing',
	#package : 'ResourcesLive',
	#tag : 'Importing'
}

{ #category : 'accessing' }
RlCopyImportStrategy >> importFile: sourceFile to: destinationFile [
	sourceFile copyTo: destinationFile
]

{ #category : 'accessing' }
RlCopyImportStrategy >> prepareResource: resource [
	| sourceFile destinationFile |
	super prepareResource: resource.
	sourceFile := resource file.
	destinationFile := self client library locationFor: resource in: self client location.
	destinationFile exists ifTrue: [ self error ].
	destinationFile parent ensureCreateDirectory.
	self importFile: sourceFile to: destinationFile.
	resource file: destinationFile.
	
	(sourceFile isKindOf: Tempfile) ifTrue: [ ^ self ].
	resource originalFile: sourceFile asFileReference
]
