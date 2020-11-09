"
I copy the resource's file into the library; leaving a copy in its original location.
"
Class {
	#name : #RlCopyImportStrategy,
	#superclass : #RlInPlaceImportStrategy,
	#category : #'ResourcesLive-Importing'
}

{ #category : #accessing }
RlCopyImportStrategy >> importFile: sourceFile to: destinationFile [
	sourceFile copyTo: destinationFile
]

{ #category : #accessing }
RlCopyImportStrategy >> prepareResource: resource [
	| sourceFile destinationFile |
	super prepareResource: resource.
	sourceFile := resource file.
	destinationFile := self client library locationFor: sourceFile basename in: self client location.
	self assert: destinationFile exists not.
	destinationFile parent ensureCreateDirectory.
	self importFile: sourceFile to: destinationFile.
	resource
		file: destinationFile;
		originalFile: sourceFile asFileReference
]
