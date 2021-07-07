"
This was the precursor to TakeNote, which adds notetaking methods. I'm not sure where things are headed yet, so I'm keeping everything around.
"
Class {
	#name : #MarkInterestingDVDClip,
	#superclass : #Object,
	#instVars : [
		'startTime',
		'endTime',
		'dvd'
	],
	#category : #'MediaPlayer-Core-Support'
}

{ #category : #'instance creation' }
MarkInterestingDVDClip class >> from: aDVD [
	
	^ self new setDVD: aDVD.
]

{ #category : #actions }
MarkInterestingDVDClip >> createClip [

	^ VideoClip from: dvd startingAt: startTime andEndingAt: endTime.
]

{ #category : #accessing }
MarkInterestingDVDClip >> defaultSecondsToSkip [
	"This will depend on what users find most useful.  In testing, 3 seconds seemed to work well."

	^ 3.
]

{ #category : #actions }
MarkInterestingDVDClip >> endHere [

	endTime := dvd position.
	self playClip.
]

{ #category : #actions }
MarkInterestingDVDClip >> endLaterBy: aNumberOfSeconds [

	endTime := endTime + aNumberOfSeconds.
	dvd position: endTime - 3.
	self playRestOfClip.
]

{ #category : #private }
MarkInterestingDVDClip >> execute [

"	dvd
		pause;
		section: title startsAt: startTime;
		position: originalTime."
]

{ #category : #actions }
MarkInterestingDVDClip >> playClip [

	dvd position: startTime.
	dvd play.
	[ [ dvd position < endTime ] whileTrue: [ (Delay forMilliseconds: 100) wait ].
	  dvd pause ] fork.
]

{ #category : #private }
MarkInterestingDVDClip >> playRestOfClip [

	dvd play.
	[ [ dvd position < endTime ] whileTrue: [ (Delay forMilliseconds: 100) wait ].
	  dvd pause ] fork.
]

{ #category : #private }
MarkInterestingDVDClip >> playUntilUserMarksEnd [

	dvd play.
]

{ #category : #private }
MarkInterestingDVDClip >> setDVD: aDVD [ 

	dvd := aDVD.
	startTime := endTime := aDVD position.
	^ self.
]

{ #category : #actions }
MarkInterestingDVDClip >> startEarlierBy: aNumberOfSeconds [

	startTime := startTime - aNumberOfSeconds.
	dvd position: startTime.
	self playUntilUserMarksEnd.
]
