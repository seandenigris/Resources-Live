Class {
	#name : #UnknownDiskInfo,
	#superclass : #Object,
	#category : #'MediaPlayer-Core'
}

{ #category : #'as yet unclassified' }
UnknownDiskInfo >> = diskInfo [

	^ true.
]

{ #category : #'as yet unclassified' }
UnknownDiskInfo >> ifUnknown: aBlock [

	^ aBlock value.
]

{ #category : #'as yet unclassified' }
UnknownDiskInfo >> rawOutput [
	self shouldBeImplemented.
]
