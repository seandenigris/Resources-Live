Class {
	#name : #RlMoveImportStrategy,
	#superclass : #RlCopyImportStrategy,
	#category : #'ResourcesLive-Importing'
}

{ #category : #accessing }
RlMoveImportStrategy >> importFile: sourceFile to: destinationFile [

	"Use a copy of sourceFile because FS move sometimes modifies the receiver"
	sourceFile copy moveTo: destinationFile
]
