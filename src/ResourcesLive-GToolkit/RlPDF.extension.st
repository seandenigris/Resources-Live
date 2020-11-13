Extension { #name : #RlPDF }

{ #category : #'*ResourcesLive-GToolkit' }
RlPDF >> asElement [
	^ Rl_hOCRElement new
		client: self;
		yourself.
]
