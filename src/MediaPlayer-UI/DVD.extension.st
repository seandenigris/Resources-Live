Extension { #name : #DVD }

{ #category : #'*mediaplayer-ui' }
DVD >> asMorph [

	^ DVDMorph on: self.
]

{ #category : #'*mediaplayer-ui' }
DVD >> openAsMorph [

	^ DVDMorph openOn: self.
]
