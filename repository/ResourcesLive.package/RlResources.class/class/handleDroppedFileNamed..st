as yet unclassified
handleDroppedFileNamed: aString

	| resource |
	resource := RlResources library import: aString asFile.
	resource asMorph openInWorld.