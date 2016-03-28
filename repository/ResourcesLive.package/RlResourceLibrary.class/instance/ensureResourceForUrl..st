accessing
ensureResourceForUrl: aUrl
	^ self resources
		detect: [ :r | r source = aUrl ]
		ifNone: [ 
			| preDownload toImport resource |
			Halt now.
			preDownload := self inbox / aUrl file.
			toImport := preDownload exists
				ifTrue: [ preDownload ]
				ifFalse: [ aUrl ].
			resource := self import: toImport.
			resource
				source: aUrl;
				yourself ]