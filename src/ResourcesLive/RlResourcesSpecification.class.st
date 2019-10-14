Class {
	#name : #RlResourcesSpecification,
	#superclass : #TestCase,
	#category : 'ResourcesLive-Specifications'
}

{ #category : #'as yet unclassified' }
RlResourcesSpecification >> testGetFilenameNoConflicts [

	| location tmp existingFile |
	tmp := RlResourceLibrary temporaryFolder.
	location := tmp locationFor: tmp / 'fileForTesting.ext' in: tmp.
	location basename should = 'fileForTesting.ext'.
	
	existingFile := (tmp / 'existingFile.ext') ensureFile.
	location := tmp locationFor: tmp / 'existingFile.ext' in: tmp.
	location basename should = 'existingFile.2.ext'.
	existingFile delete.
	
	existingFile := (tmp / 'existingFile.ext.ext2') ensureFile.
	location := tmp locationFor: tmp / 'existingFile.ext.ext2' in: tmp.
	location basename should = 'existingFile.2.ext.ext2'.
	existingFile delete.

]
