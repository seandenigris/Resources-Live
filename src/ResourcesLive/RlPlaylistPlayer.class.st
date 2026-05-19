Class {
	#name : 'RlPlaylistPlayer',
	#superclass : 'RlAbstractMediaPlayer',
	#instVars : [
		'mediaPlayers',
		'mediaStream'
	],
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'instance' }
RlPlaylistPlayer class >> on: anLlPlaylist [

	^ self new
		playlist: anLlPlaylist;
		yourself
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> currentPosition [
	
	| result |
	result := 0 seconds.
	self source items readStreamDo: [ :str |
		| anItem |
		[
			anItem := str next.
			anItem = self playerCurrent source ] 
		whileFalse: [
			result := result + anItem duration ] ].
			
	^ result + self playerCurrent currentTime
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> currentPosition: aDuration [

	| str med localDuration |
	str := self source items readStream.
	localDuration := aDuration.
	[ 
		med := str next.
		med duration >= localDuration 
			ifTrue: [ str setToEnd ]
			ifFalse: [ localDuration := localDuration - med duration ]
	]
		doWhileFalse: [ str atEnd ].
		
	self mediaCurrent: med.
	self playerCurrent currentPosition: (med duration min: localDuration)
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> currentTime [

	^ self playerCurrent currentTime
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> isMediaFirst [

	^ self mediaStream position = 0
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> isMediaLast [

	^ self mediaStream atEnd
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> isPlaying [

	^ self playerCurrent isPlaying
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> mediaCurrent [

	^ self mediaStream peek
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> mediaCurrent: anObject [

	self playerCurrent source = anObject ifTrue: [ ^ self ].
	
	self restorePlayStateAfter: [
		"Shut down existing player"
		self playerCurrent
			pause;
			quit.
			
		"Start new player"
		self mediaStream 
			setToStart;
			skipTo: anObject;
			back.
			
		self playerCurrent 
			show;
			pause;
			speed: self requestedSpeed ].
]

{ #category : 'accessing' }
RlPlaylistPlayer >> mediaPlayers [

  ^ mediaPlayers ifNil: [ mediaPlayers := Dictionary new ]
]

{ #category : 'accessing' }
RlPlaylistPlayer >> mediaPlayers: aCollection [

  mediaPlayers := aCollection
]

{ #category : 'accessing' }
RlPlaylistPlayer >> mediaStream [

  ^ mediaStream
]

{ #category : 'accessing' }
RlPlaylistPlayer >> mediaStream: anObject [

  mediaStream := anObject
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> nextSection [
	
	self playerNext
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> pause [

	self playerCurrent pause
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> play [

	self playerCurrent play
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> playerCurrent [

	^ self mediaPlayers
		at: self mediaCurrent
		ifAbsentPut: [ self mediaCurrent newPlayer ]
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> playerGtViewFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Player';
		priority: 25;
		stencil: [ RlMediaPlayerElement on: self ];
		yourself
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> playerNext [

	| mediaNext |
	self isMediaLast ifTrue: [ ^ nil ].
	
	mediaNext := self mediaStream savingPositionDo: [ self mediaStream next; peek ].
	self mediaCurrent: mediaNext.
	^ self playerCurrent
		currentTime: 0 seconds;
		yourself
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> playerPrevious [

	| mediaPrevious |
	self isMediaFirst ifTrue: [ ^ nil ].
	
	mediaPrevious := self mediaStream savingPositionDo: [ self mediaStream back; peek ].
	
	self mediaCurrent: mediaPrevious.
	
	^ self playerCurrent
		currentTime: self playerCurrent duration;
		yourself
]

{ #category : 'accessing' }
RlPlaylistPlayer >> playlist: anObject [

  source := anObject.
  mediaStream := self source items readStream
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> quit [
	
	self mediaPlayers do: #quit
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> seekBack: aDuration [ 

	| segmentTimeElapsed |
	segmentTimeElapsed := self playerCurrent currentTime.
	
	segmentTimeElapsed >= aDuration abs
		ifTrue: [ self playerCurrent seekBy: aDuration ]
		ifFalse: [ 
			self isMediaFirst
				ifTrue: [ self playerCurrent currentTime: 0 seconds ]
				ifFalse: [ 
					self playerPrevious.
					self seekBack: aDuration + segmentTimeElapsed ] ]
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> seekBy: aDuration [

	aDuration >= 0 seconds
		ifTrue: [ self seekForward: aDuration ]
		ifFalse: [ self seekBack: aDuration ]
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> seekForward: aDuration [ 

	| segmentTimeRemaining |
	segmentTimeRemaining := self playerCurrent timeRemaining.
	
	segmentTimeRemaining >= aDuration
		ifTrue: [ self playerCurrent seekBy: aDuration ]
		ifFalse: [ 
			self isMediaLast
				ifTrue: [ self playerCurrent seekBy: segmentTimeRemaining ]
				ifFalse: [ 
					self playerNext.
					self seekForward: aDuration - segmentTimeRemaining ] ]
]

{ #category : 'accessing' }
RlPlaylistPlayer >> source: anObject [

  super source: anObject.
  mediaStream := self source items readStream
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> speed [

	^ self playerCurrent speed
]

{ #category : 'as yet unclassified' }
RlPlaylistPlayer >> speed: aNumber [

	super speed: aNumber.
	self playerCurrent speed: aNumber
]
