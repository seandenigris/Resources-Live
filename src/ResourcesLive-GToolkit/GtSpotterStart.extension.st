Extension { #name : #GtSpotterStart }

{ #category : #'*ResourcesLive-GToolkit' }
GtSpotterStart >> rlGtSearchResourcesFor: aSearch [
	<gtSearch>
	
	^ aSearch explicit
		title: 'RlResource';
		"itemName: [ :result | '+ ', result fullName ];"
		priority: 100;
		search: [ :aContext | 
			| input |
			input := aContext searchQuery trimBoth.
			input asFileReference exists
				ifTrue: [ { RlResource on: input asFileReference } asAsyncStream ]
				ifFalse: [ {} asAsyncStream ] ]
]
