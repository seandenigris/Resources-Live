"
I am the intersection of a player `mode` (what you can do) and a `service` (how you do it).

##Modes
- Live - ongoing event. For example, you can get the currentTime, but can't fastforward
- Historical - we don't know when each thing happenned exactly. We are piecing together after the fact and can only give relative positions
- Recorded - has all the actions you would commonly expect from a player - play/pause, rewind, fast forward

##Services
The underlying app we use to present the media. Examples might include:
- Safari
- Chrome
- Quicktime
- VLC
 
 So far, we have Safari via AppleEvents and Playwright. In both cases, there are two points of variability - how you find page/frame where the video element lives, and how you find the video element itself. It might make sense to put this information declaratively/generically in the media and have the player use that.
"
Class {
	#name : 'RlMediaPlayer',
	#superclass : 'RlAbstractMediaPlayer',
	#instVars : [
		'mediaContainer',
		'driver',
		'media'
	],
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'accessing' }
RlMediaPlayer class >> on: anObject [ 
	^ self new
		media: anObject;
		yourself
]

{ #category : 'accessing' }
RlMediaPlayer >> currentPosition [
	^ self playable currentPosition
]

{ #category : 'accessing' }
RlMediaPlayer >> currentPosition: anObject [
	self restorePlayStateAfter: [
		self playable currentPosition: anObject ]
]

{ #category : 'accessing' }
RlMediaPlayer >> currentTime [
	^ self playable currentTime
]

{ #category : 'accessing' }
RlMediaPlayer >> currentTime: aDuration [
	self restorePlayStateAfter: [
		self playable seekTo: aDuration ]
]

{ #category : 'accessing' }
RlMediaPlayer >> driver [

	^ driver ifNil: [ driver := RlPlaywright uniqueInstance ]
]

{ #category : 'accessing' }
RlMediaPlayer >> driver: anObject [

	driver := anObject
]

{ #category : 'as yet unclassified' }
RlMediaPlayer >> duration [

	^ self media duration
]

{ #category : 'accessing' }
RlMediaPlayer >> isPlaying [
	^ self playable isPlaying
]

{ #category : 'as yet unclassified' }
RlMediaPlayer >> isRunning [
	^ mediaContainer isNil
]

{ #category : 'accessing' }
RlMediaPlayer >> media [

	^ media
]

{ #category : 'accessing' }
RlMediaPlayer >> media: anObject [

	media := anObject
]

{ #category : 'actions' }
RlMediaPlayer >> mediaContainer [
	mediaContainer ifNil: [ self show ].
	
	^ mediaContainer
]

{ #category : 'accessing' }
RlMediaPlayer >> nextSection [
	self media nextSectionIn: self mediaContainer.
	self play.
	self requestedSpeed ifNotNil: [ :spd | self speed: spd ]
]

{ #category : 'actions' }
RlMediaPlayer >> pause [
	self playable pause
]

{ #category : 'actions' }
RlMediaPlayer >> play [
	self playable play
]

{ #category : 'actions' }
RlMediaPlayer >> playable [
	^ self media playableClass in: self mediaContainer
]

{ #category : 'accessing' }
RlMediaPlayer >> previousSection [
	self media previousSectionIn: self mediaContainer.
	self play.
	self requestedSpeed ifNotNil: [ :spd | self speed: spd ]
]

{ #category : 'accessing' }
RlMediaPlayer >> quit [
	self reset
]

{ #category : 'accessing' }
RlMediaPlayer >> reset [
	mediaContainer ifNil: [ ^ self ].
	mediaContainer onQuit.
	mediaContainer := nil.
]

{ #category : 'accessing' }
RlMediaPlayer >> seekBy: aDuration [
	| target |
	target := self currentTime + aDuration max: 0 seconds.
	self currentTime: target
]

{ #category : 'actions' }
RlMediaPlayer >> show [
	self flag: 'possibly need to self media showWith: self driver to account for login, but maybe there is another solution. Leaning more and more towards custom Player classes'.
	mediaContainer := self driver show: self media.
]

{ #category : 'accessing' }
RlMediaPlayer >> speed [
	^ self playable playbackSpeed
]

{ #category : 'accessing' }
RlMediaPlayer >> speed: aNumber [

	super speed: aNumber.
	self playable playbackSpeed: aNumber
]
