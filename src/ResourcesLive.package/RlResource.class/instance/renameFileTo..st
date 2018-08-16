actions
renameFileTo: aString
	| target |
	target := self file parent / aString.
	self moveFileTo: target