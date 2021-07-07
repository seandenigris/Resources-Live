Class {
	#name : #VideoMorph,
	#superclass : #Morph,
	#instVars : [
		'video'
	],
	#category : #'MediaPlayer-UI'
}

{ #category : #'as yet unclassified' }
VideoMorph class >> on: aVideo [ 

	^ self new setModel: aVideo.
]

{ #category : #'as yet unclassified' }
VideoMorph class >> openOn: aVideo [ 

	^ (self on: aVideo)
			center: World activeHand center;
			openInWorld.
]

{ #category : #'as yet unclassified' }
VideoMorph >> initialize [

	super initialize.
	self color: Color veryVeryLightGray.
	self extent: 500@200.
]

{ #category : #private }
VideoMorph >> setModel: aVideo [ 

	video := aVideo.
	^ self.
]
