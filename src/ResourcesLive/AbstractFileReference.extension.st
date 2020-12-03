Extension { #name : #AbstractFileReference }

{ #category : #'*ResourcesLive' }
AbstractFileReference >> asRlResource [
	^ RlResource on: self
]

{ #category : #'*ResourcesLive' }
AbstractFileReference >> gtRlResourceFor: aView inContext: aContext [
	<gtView>
	| resource |
	(RlResource doesSpecificallyHandle: self)
		ifFalse: [ ^ aView empty ].
		
	resource := self asRlResource.
	^ aView composite
		title: resource displayName;
		priority: 1;
		views: (resource gtViewsInContext: aContext)
]

{ #category : #'*ResourcesLive' }
AbstractFileReference >> rlAppend: location [

	| absoluteLocation isFSMagicStringGrenade |
	"Guard against FS magic"
	isFSMagicStringGrenade := location isString and: [ #('/') includes: location ].
	isFSMagicStringGrenade ifTrue: [ ^ self error: 'Appending / to aFileLoctor brings you to the root dir!' ].
	
	absoluteLocation := self resolve: location.
	self assert: ((self contains: absoluteLocation ) or: [ self = absoluteLocation ]).
	
	^ absoluteLocation
]
