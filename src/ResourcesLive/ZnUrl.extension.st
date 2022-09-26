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
	| client base extension |
	base := self isFilePath 
		ifTrue: [ 
			self file asFileReference extension ifNotEmpty: [ ^ self file ].
			self file ]
		ifFalse: [ self asString asFilename ] .
	client := ZnClient new
		url: self;
		head;
		yourself.
	
	"Account for URLs that are technically directories but return a file type; for more info about available types, see https://www.iana.org/assignments/media-types/media-types.xhtml"
	extension := RlResource extensionForMimeType: client response contentType.
	
	^ extension
		ifNil: [ base ]
		ifNotNil: [ base, '.', extension ]
]
