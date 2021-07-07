Class {
	#name : #MediaPlayerMorph,
	#superclass : #SystemWindow,
	#category : #'MediaPlayer-UI'
}

{ #category : #'as yet unclassified' }
MediaPlayerMorph class >> dvdPlayer [

	^ self new setModel: DVDPlayer reference label: 'DVD Player'.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph class >> on: aVideo [

	^ self new setModel: aVideo label: 'Video'.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph class >> quicktime [

	^ self new setModel: CwQuickTime reference label: #CwQuickTime.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> addControls [

	| builder controls |
	builder := UITheme builder.
	controls := builder newColumn: {
		builder newRow: { self newPlayButton. self newNormalSpeedButton. self newDoubleTimeButton. self newRateControl }.
			self newTitleEditor.
			self newSeriesEditor.
			self newVideoMorph.
			self newClipButton }.
	self addMorph: controls frame: (0@0 extent: 0.8@0.8).
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> builder [

	^ UITheme builder.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> createClip [

	| presenter |
	presenter := MarkInterestingClip from: model.
	presenter morph openInWorld.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newClipButton [

	^ self builder newButtonFor: self action: #createClip label: 'Create clip' help: ''. 
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newDoubleTimeButton [

	^ self builder newButtonFor: [ model playSpeedFactor: 2 ] action: #value label: '2x' help: ''. 
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newNormalSpeedButton [

	^ self builder newButtonFor: [ model playSpeedFactor: 1 ] action: #value label: '1x' help: ''. 
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newPlayButton [

	^ PlayButton on: model.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newRateControl [

	^ self builder newRow: { 
			self builder newLabel: 'Play Speed Factor: '.
			self builder newTextEntryFor: model getText: #playSpeedFactor setText: #playSpeedFactor: help: '' }.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newSeriesEditor [

	^ self builder newRow: { 
			self builder newLabel: 'Part of: '.
			self builder newTextEntryFor: model getText: #series setText: #series: help: '' }.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newTitleEditor [

	^ self builder newRow: { 
			self builder newLabel: 'Title: '.
			self builder newTextEntryFor: model getText: #title setText: #title: help: '' }.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newViControl [
	
	^ ViVideoControlMorph on: model.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newVideoMorph [

	^ VideoMorph on: model. 
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> newVideoMorphButton [

	^ self builder newButtonFor: self action: #openVideoMorph label: 'Open video morph' help: ''. 
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> openVideoMorph [

	VideoMorph openOn: model.
]

{ #category : #'as yet unclassified' }
MediaPlayerMorph >> setModel: playableObject label: aString [

	model := playableObject.
	self
		setLabel: aString;
		addControls.
	^ self.
]
