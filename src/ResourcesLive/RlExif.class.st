Class {
	#name : 'RlExif',
	#superclass : 'Object',
	#traits : 'PeTRawDataHolder',
	#classTraits : 'PeTRawDataHolder classTrait',
	#category : 'ResourcesLive',
	#package : 'ResourcesLive'
}

{ #category : 'accessing' }
RlExif >> tagsGtSearchFor: aSearch [
	<gtSearch>
	
	^ (self rawData gtSpotterForKeysFor: aSearch)
		title: 'Tags';
		previewObject: [ :tag | self rawData at: tag ]
]
