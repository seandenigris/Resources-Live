Extension { #name : #ZnUrl }

{ #category : #'*ResourcesLive' }
ZnUrl >> asRlResource [

	| file |
	file := Tempfile named: self rlFilename.
	file parent ensureCreateDirectory.
	self saveContentsToFile: file.
	^ file asRlResource
		source: self;
		yourself
]

{ #category : #'*ResourcesLive' }
ZnUrl >> rlFilename [
	| client base |
	base := self isFilePath 
		ifTrue: [ 
			self file asFileReference extension ifNotEmpty: [ ^ self file ].
			self file ]
		ifFalse: [ self asString asFilename ] .
	client := ZnClient new
		url: self;
		head;
		yourself.
	^ String streamContents: [ :s |
		s << base.
		
		"Account for URLs that are technically directories but return HTML"
		(client response contentType matches: ZnMimeType textHtml)
			ifTrue: [ s << '.html' ] ]
]
