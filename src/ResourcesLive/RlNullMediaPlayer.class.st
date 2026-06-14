Class {
	#name : 'RlNullMediaPlayer',
	#superclass : 'Object',
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'instance creation' }
RlNullMediaPlayer class >> on: anObject [

	^ self new
]

{ #category : 'accessing' }
RlNullMediaPlayer >> currentPosition [
	^ nil
]

{ #category : 'accessing' }
RlNullMediaPlayer >> driver: anObject [
]
