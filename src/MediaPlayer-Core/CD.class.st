"
cd noteThe:
	'David Bowey opener'.

So, I have an instance of a thing that I've just encountered.  I want to add it to my tree of knowledge.  Let's say I didn't have anything even mildly related yet (the case right now in testing).

This is what I want to happen.
1. Pause the CD.
2. Mark the clip that contains the information
	a. Mark the beginning
	b. Mark the end
3. Enter the info
"
Class {
	#name : #CD,
	#superclass : #OpticalDisk,
	#instVars : [
		'player'
	],
	#classVars : [
		'CDs'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #'as yet unclassified' }
CD class >> initialize [

	CDs := OrderedCollection  new.
]

{ #category : #'as yet unclassified' }
CD class >> nameOfDiskInDrive [

	^ ITunes reference nameOfCDInDrive.
]

{ #category : #'as yet unclassified' }
CD class >> titled: aString [ 

	^ CD new setTitle: aString.
]

{ #category : #'instance creation' }
CD class >> titled: titleString onDiskNamed: diskNameString [

	^ CDs
		detect: [ :d | d title = titleString ]
		ifNone: [ CDs add: (self new setTitle: titleString diskName: diskNameString) ].
]

{ #category : #'initialize-release' }
CD >> initialize [

	player := CwQuickTime reference.
]

{ #category : #private }
CD >> markReleventClip [

	"I'm experimenting with the practice of all objects are valid, which tells me to have a different class to create the 'note' while I'm setting it up."

	^ CDClipCreator createClipFrom: self. "AndWhenCompleteSend: #clipped."
]

{ #category : #'note-taking' }
CD >> note: aString [ 

	self pause.
	self markReleventClip.
	"self enterInformation."
]

{ #category : #playing }
CD >> pause [

	player pause.
]

{ #category : #playing }
CD >> play [

	player playCD.
]

{ #category : #playing }
CD >> position [

	^ Duration seconds: player position.
]

{ #category : #playing }
CD >> position: aDuration [

	player position: aDuration.
]

{ #category : #private }
CD >> setTitle: titleString diskName: diskNameString [ 

	title := titleString.
	diskName := diskNameString.
	^ self.
]

{ #category : #playing }
CD >> skipAhead: aDuration [

	player skipAhead: aDuration.
]

{ #category : #playing }
CD >> skipBack: aDuration [

	player skipBack: aDuration.
]

{ #category : #'note-taking' }
CD >> takeNote [

	"Motivation: In the case of listening casually to a CD, I want to pause the CD when I decide to take a note because, if the note is directly sourced from the CD, it is probably near the current position.  Also, I don't want to listen and note at the same time.  I also don't necessarily know what it is that I'm noting exactly.  I'll probably take a second to fully form it."

	self pause. "This is not an expensive op and the user is interacting, so who cares about checking, just pause"
	^ TakeNote on: self. "TakeNote I think has a better work flow, but we can always restore markRelevantClip if nec. Maybe compare the two before removing completely"
"	^ self markReleventClip."
	"self enterInformation."
]
