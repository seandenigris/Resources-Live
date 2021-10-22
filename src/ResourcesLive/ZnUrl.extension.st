Extension { #name : #ZnUrl }

{ #category : #'*ResourcesLive' }
ZnUrl >> asRlResource [

	| file |
	file := FileLocator imageDirectory / 'tmp' / self rlFilename.
	file parent ensureCreateDirectory.
	self saveContentsToFile: file.
	^ file asRlResource
		source: self;
		yourself
]

{ #category : #'*ResourcesLive' }
ZnUrl >> rlFilename [
	| client |
	self isFilePath ifTrue: [ ^ self file ].
	client := ZnClient new
		url: self;
		head;
		yourself.
	^ String streamContents: [ :s |
		s << self asString asFilename.
		
		"Account for URLs that are technically directories but return HTML"
		client response contentType = ZnMimeType textHtml
			ifTrue: [ s << '.html' ] ]
]
