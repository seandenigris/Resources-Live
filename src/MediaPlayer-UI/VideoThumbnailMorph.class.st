Class {
	#name : #VideoThumbnailMorph,
	#superclass : #ImageMorph,
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
VideoThumbnailMorph class >> on: video [

	^ self new setVideo: video.
]

{ #category : #'as yet unclassified' }
VideoThumbnailMorph >> initialize [

	super initialize.
	self on: #mouseUp send: #play to: self.
]

{ #category : #'as yet unclassified' }
VideoThumbnailMorph >> play [

	self halt.
]
