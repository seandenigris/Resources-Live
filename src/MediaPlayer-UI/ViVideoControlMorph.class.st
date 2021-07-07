Class {
	#name : #ViVideoControlMorph,
	#superclass : #Morph,
	#instVars : [
		'model'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
ViVideoControlMorph class >> on: aPlayable [

	^ self new setModel: aPlayable.
]

{ #category : #'as yet unclassified' }
ViVideoControlMorph >> setModel: aPlayable [

	model := aPlayable.
	^ self.
]
