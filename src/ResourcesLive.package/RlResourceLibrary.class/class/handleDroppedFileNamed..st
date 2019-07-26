file services
handleDroppedFileNamed: aString

	| resource |
	resource := RlResourceLibrary uniqueInstance import: aString asFileReference.
	resource asMorph openInWorld.