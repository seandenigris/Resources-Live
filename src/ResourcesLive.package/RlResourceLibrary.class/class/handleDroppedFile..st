file services
handleDroppedFile: aFileReference

	| resource |
	resource := self import: aFileReference.
	resource asMorph openInWorld.