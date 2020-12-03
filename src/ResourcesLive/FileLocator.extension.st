Extension { #name : #FileLocator }

{ #category : #'*ResourcesLive' }
FileLocator >> rlAppend: location [

	| absoluteLocation |
	self flag: 'Should this be pushed up to super? The situation it addressed was pretty hairy!'.

	"Guard against FS magic"
	absoluteLocation := self resolve: location.
	self assert: ((self contains: absoluteLocation ) or: [ self = absoluteLocation ]).
	
	^ absoluteLocation
]
