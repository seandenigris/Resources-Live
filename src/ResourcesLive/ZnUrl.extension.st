Extension { #name : #ZnUrl }

{ #category : #'*ResourcesLive' }
ZnUrl >> asRlResource [

	| file |
	file := FileLocator imageDirectory / 'tmp' / self file.
	file parent ensureCreateDirectory.
	self saveContentsToFile: file.
	^ file asRlResource
		source: self;
		yourself
]
