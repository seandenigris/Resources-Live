Extension { #name : #RlPDF }

{ #category : #'*ResourcesLive-GToolkit' }
RlPDF >> asElement [
	| container image |
	container := BlElement new
		size: self imageFile asRlResource extent;
		yourself.
	image := GtFileUtility imageElementFromFileReference: self imageFile.
	container addChild: image.
	^ container.
]

{ #category : #'*ResourcesLive-GToolkit' }
RlPDF >> asElementHighlightingWords [
	| result |
	result := self asElement.
	self hocr words do: [ :w | 
		| wordElement |
		wordElement := w asElement
			addEventHandlerOn: BlElementSelectionAcquiredEvent
			do: [ :anEvent | anEvent target owner border: (BlBorder builder width: 2; paint: Color blue; build)  ];
		addEventHandlerOn: BlElementSelectionLostEvent
			do: [ :anEvent | anEvent target owner border: BlBorder empty ];
			yourself.
	result addChild: wordElement ].
	result addEventHandler: RlBlOcrSelectionHandler new.
	^ result
]

{ #category : #'*ResourcesLive-GToolkit' }
RlPDF >> asOCRElement [
	| result |
	result := self asElementHighlightingWords.
	result when: BlDragStartEvent do: [ :anEvent | 
		anEvent consumed: true.
		self inspect ].
	^ result
]
