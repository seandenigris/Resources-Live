"
Instance creation.  What a 'valid object' is depends on how it's going to be used.  I can think of two use cases so far:
	1. I want to talk about a disc that I heard about, but don't have access to it.
	2. I am working with a disc that I have

I think conceptually, we think of discs as their title e.g. ""Top Gun"" or ""Led Zeplin's..."".  Although now that I say that, I think that those titles refer to the work contained on the disc, not the dics itself - after all, you could still find Top Gun on VHS!  So the disc is really a medium on which *something* - a movie, album, conference - is recorded.  When I say 'the movie Top Gun', I probably want it on the highest-quality medium possible, but don't consider it a different movie.  So in the domain, the work has media on which it's available.

Movie play ^ self highestQualitySource play.

But back to the matter at hand.  If I'm at my computer, and I say, through whatever process, ""topGunCD play"", I want the damn thing to start playing.  We'll assume that I've listened to it before, since that is the only use case I have so far.  If it's not available, I want it to tell me, ""hey buddy, where is the damn thing?""

So aPieceOfInfoThatMattersToMe experience
	^ source play. ""where source may be a disc""

So is it:
""(system isAvailable: topGunCD) ifTrue: topGunCD play""?
or
""topGunCD play
	player play: self
	
Player>>play: aDisc
	(self currentDisc = aDisc)
		ifTrue: [ aDisc play ]
		ifFalse: [ now what? ]""
		
Jumping around in a disc:
	We choose to use ""skipBack:"" & ""skipAhead:"" instead of ""rewind"" and ""fast forward"" because the latter imply a gradual advance from point A to point B, where here, we're jumping right to the requested relative position.
"
Class {
	#name : #OpticalDisk,
	#superclass : #Object,
	#instVars : [
		'title',
		'diskName'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #'as yet unclassified' }
OpticalDisk class >> drive [

	^ OpticalDrive local.
	"See history: Couldn't find any properties that were optical-drive-specific, but ejectable works for now."
]

{ #category : #'as yet unclassified' }
OpticalDisk class >> eject [

	Applescript doIt: '
		tell application "Finder"
			do shell script ("drutil eject")
		end tell'.
]

{ #category : #'as yet unclassified' }
OpticalDisk class >> nameOfDiskInDrive [

	| dvdDrive |
	dvdDrive := MacSystem local disks detect: [ :drive | drive isOptical ].
	^ dvdDrive diskName.
]

{ #category : #'as yet unclassified' }
OpticalDisk >> eject [

	DrUtil eject.
]

{ #category : #testing }
OpticalDisk >> isAvailable [

	^ MacSystem local disks anySatisfy: [ :disk | disk diskName = diskName ].
]

{ #category : #private }
OpticalDisk >> setTitle: aString [ 

	title := aString.
]

{ #category : #private }
OpticalDisk >> title [

	^ title.
]
