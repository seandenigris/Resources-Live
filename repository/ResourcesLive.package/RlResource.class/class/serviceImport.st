services
serviceImport

	| entry |
	entry := SimpleServiceEntry 
		provider: RlResourceLibrary uniqueInstance
		label: 'Import ', (self name allButFirst: 2) asLowercase
		selector: #importFile:
		description: ''
		buttonLabel: 'Import'.
	^ entry
		argumentGetter: [ :fs | fs name asFileReference ];
		yourself