Extension { #name : #DateAndTime }

{ #category : #'*ResourcesLive' }
DateAndTime class >> rlImportTimestamp [
	^ self now translateToUTC
]
