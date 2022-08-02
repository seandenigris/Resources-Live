Class {
	#name : #RlAudio,
	#superclass : #RlResource,
	#traits : 'RlTPlayable',
	#classTraits : 'RlTPlayable classTrait',
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlAudio class >> fileExtensions [
	^ #('m4a')
]
