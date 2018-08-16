as yet unclassified
ensureFileCopiedInto: folder asBase: base
	| reference |
	reference := folder / base, self class fileExtensions first.
	reference exists ifTrue: [ ^ self ].
	self verifiedCopyFileTo: reference