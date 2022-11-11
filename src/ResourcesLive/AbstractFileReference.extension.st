Extension { #name : #AbstractFileReference }

{ #category : #'*ResourcesLive' }
AbstractFileReference >> asRlResource [
	^ RlResource on: self
]

{ #category : #'*ResourcesLive' }
AbstractFileReference >> gtRlResourceFor: aView [
	<gtView>
	| resource |
	(RlResource doesSpecificallyHandle: self)
		ifFalse: [ ^ aView empty ].
		
	resource := self asRlResource.
	^ aView forward
		title: resource displayName;
		object: [ resource ];
		priority: 1;
		view: #gtMetaFor:;
		inspectButtonFor: resource
]

{ #category : #'*ResourcesLive' }
AbstractFileReference >> rlAppend: location [

	| absoluteLocation isFSMagicStringGrenade |
	"Guard against FS magic"
	isFSMagicStringGrenade := location isString and: [ #('/') includes: location ].
	isFSMagicStringGrenade ifTrue: [ ^ self error: 'Appending / to aFileLoctor brings you to the root dir!' ].
	
	absoluteLocation := self resolve: location.
	((self contains: absoluteLocation ) or: [ self = absoluteLocation ])
		ifFalse: [ self error ].
	
	^ absoluteLocation
]
