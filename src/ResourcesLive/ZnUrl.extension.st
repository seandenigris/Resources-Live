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
	^ self isFilePath
		ifTrue: [ self file ]
		ifFalse: [ self asString asFilename ]
]
