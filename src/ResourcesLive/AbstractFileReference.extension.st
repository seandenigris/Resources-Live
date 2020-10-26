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
