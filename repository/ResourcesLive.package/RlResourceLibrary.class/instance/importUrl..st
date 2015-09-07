as yet unclassified
importUrl: aUrl

	| data file class |
	data := aUrl retrieveContents.
	file := FileLocator imageDirectory / 'tmp' / aUrl file.
	file parent ensureCreateDirectory.
	file writeStreamDo: [ : str | str binary; nextPutAll: data ].

	class := RlResource allSubclasses detect: [ :e | e fileExtensions includes: file extension ].
	^ class importFromFile: file.