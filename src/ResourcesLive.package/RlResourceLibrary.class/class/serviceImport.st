file services
serviceImport

	| entry |
	entry := SimpleServiceEntry 
		provider: self
		label: 'Import as resource'
		selector: #handleDroppedFile:
		description: ''
		buttonLabel: 'Import'.
	^ entry
		argumentGetter: [ :fs | fs name asFileReference ];
		yourself