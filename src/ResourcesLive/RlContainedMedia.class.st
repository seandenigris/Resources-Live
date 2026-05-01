Class {
	#name : 'RlContainedMedia',
	#superclass : 'Object',
	#instVars : [
		'container'
	],
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'instance creation' }
RlContainedMedia class >> in: container [

	^ self new
		container: container;
		yourself
]

{ #category : 'accessing' }
RlContainedMedia >> container [
	^ container
]

{ #category : 'accessing' }
RlContainedMedia >> container: anObject [
	container := anObject
]

{ #category : 'accessing' }
RlContainedMedia >> currentTime [
	^ self container currentTime seconds
]

{ #category : 'testing' }
RlContainedMedia >> isPlaying [
	^ self container isPlaying
]

{ #category : 'controlling' }
RlContainedMedia >> pause [
	self container pause
]

{ #category : 'controlling' }
RlContainedMedia >> play [
	self container play
]

{ #category : 'accessing' }
RlContainedMedia >> playbackSpeed [
	^ self container speed
]

{ #category : 'accessing' }
RlContainedMedia >> playbackSpeed: aNumber [
	self container speed: aNumber
]

{ #category : 'controlling' }
RlContainedMedia >> seekTo: aDuration [
	self container seekTo: aDuration
]
