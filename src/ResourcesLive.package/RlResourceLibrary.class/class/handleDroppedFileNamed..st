file services
handleDroppedFileNamed: aFileReference

	| resource |
	resource := self import: aFileReference.
	resource asMorph openInWorld.