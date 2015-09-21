*ResourcesLive
asRlResource

	| data file |
	data := self retrieveContents.
	file := FileLocator imageDirectory / 'tmp' / self file.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ :str | str binary; nextPutAll: data ].
	^ file asRlResource