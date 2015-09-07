as yet unclassified
handleDroppedFileNamed: aString

	| resource |
	resource := Resources library import: aString asFile.
	resource asMorph openInWorld.