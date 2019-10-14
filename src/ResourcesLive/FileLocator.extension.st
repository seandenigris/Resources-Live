Extension { #name : #FileLocator }

{ #category : #'*ResourcesLive' }
FileLocator >> rlAppend: location [

	| absoluteLocation relativePath |

	"Guard against FS magic"
	absoluteLocation := self resolve: location.
	self assert: ((self contains: absoluteLocation ) or: [ self = absoluteLocation ]).
	
	relativePath := self makeRelative: absoluteLocation.
	^ self withPath: relativePath
]
