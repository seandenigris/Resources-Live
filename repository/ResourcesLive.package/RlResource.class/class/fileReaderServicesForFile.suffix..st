as yet unclassified
fileReaderServicesForFile: fullName suffix: suffix
	<fileService>
	^ (self fileExtensions includes: suffix)
		ifTrue: [ { self serviceImport } ]
		ifFalse: [ {} ].