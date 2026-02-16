Extension { #name : 'RlPDF' }

{ #category : '*ResourcesLive-GToolkit' }
RlPDF >> asElement [
	^ RlHOCRElement new
		client: self;
		yourself.
]
