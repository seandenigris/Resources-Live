file services
fileReaderServicesForFile: fullName suffix: suffix
	<fileService>
	^ (RlResource allFileExtensions includes: suffix)
		ifTrue: [ { self serviceImport } ]
		ifFalse: [ {} ].