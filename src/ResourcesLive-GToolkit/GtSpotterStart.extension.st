Extension { #name : #GtSpotterStart }

{ #category : #'*ResourcesLive-GToolkit' }
GtSpotterStart >> rlGtSearchResourcesFor: aSearch [
	<gtSearch>
	
	| stringToResources |
	stringToResources := [ :input |
		| resourceable |
		input asFileReference exists ifTrue: [ resourceable := input asFileReference ].
		input isValidAbsoluteURL ifTrue: [ resourceable := input asUrl ].
		resourceable
			ifNil: [ {} ]
			ifNotNil: [ { resourceable asRlResource } ] ].
	
	^ aSearch explicit
		title: 'RlResource';
		priority: 100;
		search: [ :aContext | 
			| input |
			input := aContext searchQuery trimBoth.
			(stringToResources value: input) asAsyncStream ]
]
