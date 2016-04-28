as yet unclassified
moveInto: aFolder
	| newReference |
	newReference := aFolder / self basename.
	self file moveTo: newReference.
	self file: newReference.