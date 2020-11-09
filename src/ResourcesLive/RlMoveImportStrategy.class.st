Class {
	#name : #RlMoveImportStrategy,
	#superclass : #RlCopyImportStrategy,
	#category : #'ResourcesLive-Importing'
}

{ #category : #accessing }
RlMoveImportStrategy >> importFile: sourceFile to: destinationFile [
	sourceFile moveTo: destinationFile
]
