Class {
	#name : #MarkClipMorph,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
MarkClipMorph class >> on: aVideo [ 

	| model |
	model := MarkInterestingClip in: aVideo.
	^ self new setModel: model.
]

{ #category : #'as yet unclassified' }
MarkClipMorph >> setModel: aMarkInterestingClip [

	model := aMarkInterestingClip.
	^ self.
]
