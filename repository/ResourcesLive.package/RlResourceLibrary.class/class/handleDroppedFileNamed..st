as yet unclassified
handleDroppedFileNamed: aString

	| resource |
	resource := RlResourceLibrary library import: aString asFile.
	resource asMorph openInWorld.