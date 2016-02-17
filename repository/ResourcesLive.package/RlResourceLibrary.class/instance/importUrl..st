importing
importUrl: aUrl

	| data file |
	data := aUrl retrieveContents.
	file := FileLocator imageDirectory / 'tmp' / aUrl file.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ : str | str binary; nextPutAll: data ].
	^ self importFile: file