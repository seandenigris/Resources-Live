Class {
	#name : 'RlAbstractMediaPlayer',
	#superclass : 'Object',
	#instVars : [
		'requestedSpeed',
		'source'
	],
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'as yet unclassified' }
RlAbstractMediaPlayer >> currentTime [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
RlAbstractMediaPlayer >> duration [
	self subclassResponsibility
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> isPlaying [
	self subclassResponsibility
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> isPlaying: aBoolean [
	
	aBoolean
		ifTrue: [ self play ]
		ifFalse: [ self pause ]
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> pause [
	self subclassResponsibility
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> play [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
RlAbstractMediaPlayer >> playerGtViewFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Player';
		priority: 25;
		stencil: [ RlMediaPlayerElement on: self ];
		yourself
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> requestedSpeed [

	^ requestedSpeed
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> requestedSpeed: aNumber [

	requestedSpeed := aNumber
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> restorePlayStateAfter: aBlock [
	| playState |
	playState := self isPlaying.
	aBlock value.
	self isPlaying: playState
	
	"Note: this was first needed because it seemed that seeking via Playwright driver plays the video even if it wasn't already"
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> source [

	^ source
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> source: anObject [

	source := anObject
]

{ #category : 'as yet unclassified' }
RlAbstractMediaPlayer >> speed: aNumber [

	self requestedSpeed: aNumber.
]

{ #category : 'as yet unclassified' }
RlAbstractMediaPlayer >> timeRemaining [

	^ self duration - self currentTime
]

{ #category : 'accessing' }
RlAbstractMediaPlayer >> togglePlayPause [
	self isPlaying
		ifTrue: [ self pause ]
		ifFalse: [ self play ]
]
