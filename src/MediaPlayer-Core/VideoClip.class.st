"
I keep getting more and more general. I started life as a DVDClip, then OpticalDiskClip. Eventually, I will probably become an AVClip or MediaClip. I delegate all the playing to the underlying media, which have common interfaces, like play, pause, etc.

This might help chasing down the process bug:
VideoClip allInstances collect: [ :e |
	e instVarNamed: 'backgroundProcess' ]
"
Class {
	#name : #VideoClip,
	#superclass : #Object,
	#traits : 'RlTPlayable',
	#classTraits : 'RlTPlayable classTrait',
	#instVars : [
		'startTime',
		'endTime',
		'video',
		'backgroundProcess',
		'subtitle'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #'instance creation' }
VideoClip class >> from: aVideo startingAt: startString andEndingAt: endString [ 

	^ self new setCD: aVideo startTime: startString endTime: endString.
]

{ #category : #'as yet unclassified' }
VideoClip >> asMorph [
	
	| morph playButton builder pauseButton controls |
	builder := UITheme builder.
	morph := UserObjectMorph on: self.
	playButton := builder newButtonFor: self action: #play label: 'Play' help: ''.
	pauseButton := builder newButtonFor: self action: #pause label: 'Pause' help: ''.
	controls := builder newColumn: {
		builder newRow: { playButton. pauseButton }.
		builder newTextEntry model: self; accessor: #subtitle; get }.
	morph addControls: controls.
	^ morph.
]

{ #category : #playing }
VideoClip >> backgroundProcess: aProcess [

	backgroundProcess ifNotNil: [ :process | process terminate ].
	backgroundProcess := aProcess.
]

{ #category : #playing }
VideoClip >> isPlaying [

	^ backgroundProcess isNil not and: [ backgroundProcess isTerminated not ].
]

{ #category : #'as yet unclassified' }
VideoClip >> open [

	self asMorph openInWorld.
]

{ #category : #playing }
VideoClip >> play [
	"I think this should ultimately be delegated to the player. It's only necessary to fork with either QT or DVDPlayer (I forget which, but I guess DVD Player since that's what we're dealing with - although this could've been a cut and paste job. This again points to the need for executable documentation of assumptions) because you can't specify a fractional second (although we should check the underlying Cocoa framework at some point, which may expose more functionality).
	The whole thing would become:
		disc playFrom: startTime to: endTime"

	| originalPosition |
	self flag: #nvdn.
	video play.
	originalPosition := video position.
	video position: startTime.
	self isPlaying ifTrue: [ ^ self ].
	self backgroundProcess: [ [ video position < endTime ] whileTrue: [ (Delay forMilliseconds: 100) wait ].
		video pause.
		video position: originalPosition.
		backgroundProcess := nil ] fork.
]

{ #category : #playing }
VideoClip >> player [

	^ video.
]

{ #category : #playing }
VideoClip >> printOn: aStream [

	| prettyStartTime prettyEndTime |
	prettyStartTime := startTime roundTo: (Duration seconds: 1).
	prettyEndTime := endTime roundTo: (Duration seconds: 1).
	aStream nextPutAll: 'Clip from ', prettyStartTime asString, ' to ', prettyEndTime asString, ' in '.
	video printOn: aStream.
]

{ #category : #private }
VideoClip >> setCD: aCD startTime: startString endTime: endString [

	video := aCD.
	startTime := startString.
	endTime := endString.
	subtitle := ''.
	^ self.
]

{ #category : #'as yet unclassified' }
VideoClip >> subtitle [

	^ subtitle.
]

{ #category : #'as yet unclassified' }
VideoClip >> subtitle: aString [

	subtitle := aString.
]
