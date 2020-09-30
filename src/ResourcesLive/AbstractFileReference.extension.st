Extension { #name : #AbstractFileReference }

{ #category : #'*ResourcesLive' }
AbstractFileReference >> asRlResource [
	^ RlResource on: self
]

{ #category : #'*ResourcesLive' }
AbstractFileReference >> gtRlResourceFor: aView inContext: aContext [
	<gtView>
	(RlResource doesSpecificallyHandle: self)
		ifFalse: [ ^ aView empty ].
	^ aView composite
		title: 'Resource';
		priority: 1;
		views: (self asRlResource gtViewsInContext: aContext)
]
