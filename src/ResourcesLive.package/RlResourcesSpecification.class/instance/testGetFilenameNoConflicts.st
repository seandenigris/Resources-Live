as yet unclassified
testGetFilenameNoConflicts

	| location tmp existingFile |
	tmp := RlResourceLibrary temporaryFolder.
	location := tmp locationFor: tmp / 'fileForTesting.ext'.
	location basename should = 'fileForTesting.ext'.
	
	existingFile := (tmp / 'existingFile.ext') ensureFile.
	location := tmp locationFor: tmp / 'existingFile.ext'.
	location basename should = 'existingFile.2.ext'.
	existingFile delete.
	
	existingFile := (tmp / 'existingFile.ext.ext2') ensureFile.
	location := tmp locationFor: tmp / 'existingFile.ext.ext2'.
	location basename should = 'existingFile.2.ext.ext2'.
	existingFile delete.
