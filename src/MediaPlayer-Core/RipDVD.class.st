Class {
	#name : #RipDVD,
	#superclass : #Object,
	#instVars : [
		'dvd',
		'announcer'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #'as yet unclassified' }
RipDVD class >> on: aDVD [

	^ self new setDVD: aDVD.
]

{ #category : #'as yet unclassified' }
RipDVD >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ].
]

{ #category : #'as yet unclassified' }
RipDVD >> execute [

	| target command |
	target := FileSystem disk root resolve: '/Users/sean/jjj.mp4'.
	command := HandBrake transcode: dvd deviceFile to: target.
	command execute.
]

{ #category : #'as yet unclassified' }
RipDVD >> on: anAnnouncement do: aBlock [

	^ self announcer on: anAnnouncement do: aBlock.
]

{ #category : #'as yet unclassified' }
RipDVD >> setDVD: aDVD [

	dvd := aDVD.
	^ self.
]
