Class {
	#name : 'RlDomVideo',
	#superclass : 'RlDomElementLocator',
	#category : 'ResourcesLive-Web Driving',
	#package : 'ResourcesLive',
	#tag : 'Web Driving'
}

{ #category : 'as yet unclassified' }
RlDomVideo class >> in: page [
	"Default querySelector is sufficient unless there are multiple videos on a page to distinguish, which can be done via e.g. ID or class"

	^ self
		querySelector: 'video'
		in: page
]

{ #category : 'as yet unclassified' }
RlDomVideo >> currentPosition [
	"Subclasses may override if e.g. video has seekable chapters, slides, etc"
	^ self currentTime
]

{ #category : 'as yet unclassified' }
RlDomVideo >> currentPosition: aDuration [
	"Subclasses may override if e.g. video has seekable chapters, slides, etc"
	self seekTo: aDuration
]

{ #category : 'as yet unclassified' }
RlDomVideo >> currentTime [

	| secondsString |
	secondsString := self doJavaScript: 'currentTime'.
	^ secondsString asNumber seconds
]

{ #category : 'as yet unclassified' }
RlDomVideo >> duration [
	
	| secondsString |
	secondsString := self doJavaScript: 'duration'.
	^ secondsString asNumber seconds.
]

{ #category : 'as yet unclassified' }
RlDomVideo >> isPlaying [
	
	self page exists ifFalse: [ ^ false ].
	
	^ (self doJavaScript: 'paused') not.
]

{ #category : 'as yet unclassified' }
RlDomVideo >> pause [
	self doJavaScript: 'pause()'.
]

{ #category : 'as yet unclassified' }
RlDomVideo >> play [
	self doJavaScript: 'play()'.
]

{ #category : 'as yet unclassified' }
RlDomVideo >> playbackSpeed [
	^ self doJavaScript: 'playbackRate'.
]

{ #category : 'as yet unclassified' }
RlDomVideo >> playbackSpeed: aNumber [
	self doJavaScript: 'playbackRate=', aNumber asString.
]

{ #category : 'as yet unclassified' }
RlDomVideo >> seekTo: aDuration [
	self doJavaScript: 'currentTime = ', aDuration asSeconds asString.
]
