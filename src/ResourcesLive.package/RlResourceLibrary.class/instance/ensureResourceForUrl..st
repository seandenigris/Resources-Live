accessing
ensureResourceForUrl: aUrl
	^ self resources
		detect: [ :r | r source equals: aUrl ]
		ifNone: [ 
			| preDownload toImport resource |
			preDownload := self inbox / aUrl file.
			toImport := preDownload exists
				ifTrue: [ preDownload ]
				ifFalse: [ aUrl ].
			resource := self import: toImport.
			resource
				source: aUrl;
				yourself ]