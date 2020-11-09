Extension { #name : #FileLocator }

{ #category : #'*ResourcesLive' }
FileLocator >> rlAppend: location [

	| absoluteLocation relativePath |
	self flag: 'Should this be pushed up to super? The first thing to do would be to write tests to clearly understand how it works, because the situation it addressed was pretty hairy!'.

	"Guard against FS magic"
	absoluteLocation := self resolve: location.
	self assert: ((self contains: absoluteLocation ) or: [ self = absoluteLocation ]).
	
	relativePath := self makeRelative: absoluteLocation.
	^ self withPath: relativePath
]
