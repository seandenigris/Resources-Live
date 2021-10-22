Trait {
	#name : #RlTPlayable,
	#category : 'ResourcesLive'
}

{ #category : #playing }
RlTPlayable >> isPlaying [

	^ self player isPlaying: self.
]

{ #category : #playing }
RlTPlayable >> pause [

	self player pause.
]

{ #category : #playing }
RlTPlayable >> play [
	
	self player play.
]

{ #category : #playing }
RlTPlayable >> playSpeedFactor [

	^ self player playSpeedFactor.
]

{ #category : #playing }
RlTPlayable >> playSpeedFactor: aNumber [

	^ self player playSpeedFactor: aNumber.
]

{ #category : #playing }
RlTPlayable >> position [

	^ self player position.
]

{ #category : #playing }
RlTPlayable >> position: aDuration [

	self player position: aDuration.
]

{ #category : #playing }
RlTPlayable >> skipAhead: aDuration [

	self player skipAhead: aDuration.
]

{ #category : #playing }
RlTPlayable >> skipBack: aDuration [

	self player skipBack: aDuration.
]
