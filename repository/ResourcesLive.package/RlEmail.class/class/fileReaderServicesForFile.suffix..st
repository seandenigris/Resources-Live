as yet unclassified
fileReaderServicesForFile: fullName suffix: suffix
	<fileService>
	^ ({ 'eml'. 'emlx' } includes: suffix)
		ifTrue: [ { self serviceImportEmail } ]
		ifFalse: [ {} ].