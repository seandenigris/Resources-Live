Class {
	#name : #RlResourcesSpecification,
	#superclass : #TestCase,
	#category : 'ResourcesLive-Specifications'
}

{ #category : #'as yet unclassified' }
RlResourcesSpecification >> testGetFilenameNoConflicts [

	| location tmp existingFile lib |
	lib := RlResourceLibrary temporary.
	location := lib locationFor: (lib temporaryFolder / 'fileForTesting.ext') asRlResource in: lib folder.
	location basename should equal: 'fileForTesting.ext'.
	
	existingFile := (lib folder / 'existingFile.ext') ensureCreateFile.
	location := lib locationFor: existingFile asRlResource in: lib folder.
	location basename should equal: 'existingFile.2.ext'.
	existingFile delete.
	
	existingFile := (lib folder / 'existingFile.ext.ext2') ensureCreateFile.
	location := lib locationFor: existingFile asRlResource in: lib folder.
	location basename should equal: 'existingFile.2.ext.ext2'.
	existingFile delete.

]
