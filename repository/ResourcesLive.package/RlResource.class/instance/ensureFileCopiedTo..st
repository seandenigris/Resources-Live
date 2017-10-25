as yet unclassified
ensureFileCopiedTo: reference
	reference exists ifTrue: [ ^ self ].
	self verifiedCopyFileTo: reference