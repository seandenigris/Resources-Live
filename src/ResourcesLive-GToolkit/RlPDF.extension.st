Extension { #name : #RlPDF }

{ #category : #'*ResourcesLive-GToolkit' }
RlPDF >> asElement [
	^ RlhOCRElement new
		client: self;
		yourself.
]
