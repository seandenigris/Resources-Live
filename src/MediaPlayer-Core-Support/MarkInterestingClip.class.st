Class {
	#name : #MarkInterestingClip,
	#superclass : #Object,
	#instVars : [
		'startTime',
		'endTime',
		'dvd',
		'subtitleControl'
	],
	#category : #'MediaPlayer-Core-Support'
}

{ #category : #'instance creation' }
MarkInterestingClip class >> from: aDVD [
	
	^ self new setDVD: aDVD.
]

{ #category : #'instance creation' }
MarkInterestingClip class >> in: aDVD [
	
	^ self new setDVD: aDVD.
]

{ #category : #actions }
MarkInterestingClip >> createClip [

	| clip |
	clip := VideoClip from: dvd startingAt: startTime andEndingAt: endTime.
	^ clip
			subtitle: subtitleControl accept; getText;
			yourself.
]

{ #category : #accessing }
MarkInterestingClip >> defaultSecondsToSkip [
	"This will depend on what users find most useful.  In testing, 3 seconds seemed to work well."

	^ 3.
]

{ #category : #actions }
MarkInterestingClip >> endHere [

	endTime := dvd position.
	self playClip.
]

{ #category : #actions }
MarkInterestingClip >> endLaterBy: aNumberOfSeconds [

	endTime := endTime + aNumberOfSeconds.
	dvd position: endTime - 3.
	self playRestOfClip.
]

{ #category : #private }
MarkInterestingClip >> execute [

"	dvd
		pause;
		section: title startsAt: startTime;
		position: originalTime."
]

{ #category : #'as yet unclassified' }
MarkInterestingClip >> morph [

	| builder contents window |
	builder := UITheme builder.
	subtitleControl := builder newTextEntry holdingItsOwnValue; get.
	contents := builder newColumn: {
		builder newButtonFor: self action: #playUntilUserMarksEnd label: 'Play video' help: ''.
		builder newButtonFor: self action: #startHere label: 'Start here' help: ''.
		builder newButtonFor: self action: #endHere label: 'End here' help: ''.
		builder newButtonFor: self action: #playClip label: 'Play clip' help: ''.
		subtitleControl.
		builder newButtonFor: self action: #saveClip label: 'Save clip' help: '' }.
	window := builder newWindowFor: self title: 'Create a clip'.
	window addMorph: contents fullFrame: (LayoutFrame 
				fractions: (0 @ 0 corner: 1 @ 1)
				offsets: (0 @ 0 corner: 0 @ 0)).
	^ window.
]

{ #category : #actions }
MarkInterestingClip >> playClip [

	dvd position: startTime.
	dvd play.
	[ [ dvd position < endTime ] whileTrue: [ (Delay forMilliseconds: 100) wait ].
	  dvd pause ] fork.
]

{ #category : #private }
MarkInterestingClip >> playRestOfClip [

	dvd play.
	[ [ dvd position < endTime ] whileTrue: [ (Delay forMilliseconds: 100) wait ].
	  dvd pause ] fork.
]

{ #category : #private }
MarkInterestingClip >> playUntilUserMarksEnd [

	dvd play.
]

{ #category : #actions }
MarkInterestingClip >> saveClip [

	dvd addClip: self createClip.
]

{ #category : #private }
MarkInterestingClip >> setDVD: aDVD [ 

	dvd := aDVD.
	startTime := endTime := aDVD position.
	^ self.
]

{ #category : #actions }
MarkInterestingClip >> startEarlierBy: aNumberOfSeconds [

	startTime := startTime - aNumberOfSeconds.
	dvd position: startTime.
	self playUntilUserMarksEnd.
]

{ #category : #actions }
MarkInterestingClip >> startHere [

	startTime := dvd position.
	self playUntilUserMarksEnd.
]
