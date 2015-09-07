as yet unclassified
handleDroppedFileNamed: aString

	| resource |
	self error: 'Doesn''t work. See how email does it'.
	resource := RlResourceLibrary library import: aString asFile.
	resource asMorph openInWorld.