"
PlayButton new openInWorld.
"
Class {
	#name : #PlayButton,
	#superclass : #CircleMorph,
	#instVars : [
		'playLabel',
		'pauseLabel',
		'isPlaying',
		'model'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
PlayButton class >> on: model [

	^ self new setModel: model.
]

{ #category : #private }
PlayButton >> createLabels [

	playLabel := self createPlayLabel.
	pauseLabel := self createPauseLabel.
]

{ #category : #private }
PlayButton >> createPauseLabel [

	| firstStripe secondStripe |
	pauseLabel := Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		extent: 60@50.

	firstStripe := Morph new color: Color black.
	secondStripe := firstStripe duplicate.

	pauseLabel
		addMorph: firstStripe fullFrame: (LayoutFrame fractions: (0@0 corner: 0.33@1));
		addMorph: secondStripe fullFrame: (LayoutFrame fractions: (0.66@0 corner: 1@1)).
	^ pauseLabel.
]

{ #category : #private }
PlayButton >> createPlayLabel [

	^ PolygonMorph
		vertices: { 100@100. 200@150. 100@200 }
		color: Color black
		borderWidth: 1 borderColor: Color black.
]

{ #category : #private }
PlayButton >> hideLabel: aLabel [

	self removeMorph: aLabel.
]

{ #category : #initialization }
PlayButton >> initialize [

	super initialize.
	self color: Color lightGray twiceLighter.
	self initializeLabels.
	isPlaying := false.
	self on: #mouseUp send: #togglePlayAndPause to: self.
]

{ #category : #private }
PlayButton >> initializeLabels [

	self layoutPolicy: ProportionalLayout new.
	self createLabels.
	self showLabel: playLabel.
]

{ #category : #private }
PlayButton >> isPlaying [

	^ self model isPlaying.
]

{ #category : #private }
PlayButton >> model [

	^ model
]

{ #category : #private }
PlayButton >> pause [

	self model pause.
	isPlaying := false.
	self hideLabel: pauseLabel.
	self showLabel: playLabel.
]

{ #category : #private }
PlayButton >> play [

	self model play.
	isPlaying := true.
	self hideLabel: playLabel.
	self showLabel: pauseLabel.
]

{ #category : #private }
PlayButton >> setModel: playableObject [

	model := playableObject.
	 ^ self.
]

{ #category : #private }
PlayButton >> showLabel: aLabel [

	self
		addMorph: aLabel
		fullFrame: (LayoutFrame fractions: (0.25@0.25 corner: 0.75 @ 0.75)).
]

{ #category : #private }
PlayButton >> step [

"	self syncPlayState."
]

{ #category : #private }
PlayButton >> stepTime [

	^ 200.
]

{ #category : #private }
PlayButton >> syncPlayState [

	(self model isPlaying and: [ isPlaying not ]) ifTrue: [
		isPlaying := true.
		self hideLabel: playLabel.
		self showLabel: pauseLabel ].
	
	(self model isPlaying not and: [ isPlaying ]) ifTrue: [
		isPlaying := false.
		self hideLabel: pauseLabel.
		self showLabel: playLabel ].
]

{ #category : #'event handling' }
PlayButton >> togglePlayAndPause [

	self isPlaying
		ifTrue: [ self pause ]
		ifFalse: [ self play ].
]

{ #category : #private }
PlayButton >> useLabel: aLabel [

	self removeMorph: aLabel.
	self
		addMorph: aLabel
		fullFrame: (LayoutFrame fractions: (0.25@0.2 corner: 0.85 @ 0.8)).
]
