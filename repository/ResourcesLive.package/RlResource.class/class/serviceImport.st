as yet unclassified
serviceImport

	^ SimpleServiceEntry 
		provider: self 
		label: 'Import ', (self name allButFirst: 2) asLowercase
		selector: #importFromFile:
		description: ''
		buttonLabel: 'Import'