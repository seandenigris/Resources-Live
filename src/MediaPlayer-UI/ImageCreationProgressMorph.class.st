Class {
	#name : #ImageCreationProgressMorph,
	#superclass : #Morph,
	#instVars : [
		'model'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
ImageCreationProgressMorph class >> on: model [

	^ self new setModel: model.
]

{ #category : #'as yet unclassified' }
ImageCreationProgressMorph >> initialize [

	super initialize.
	self extent: 70@15.
]

{ #category : #private }
ImageCreationProgressMorph >> setModel: modelObject [

	model := modelObject.
	model onDiskImageStatusUpdateDo: [ :a | self update: a ].
	^ self.
]

{ #category : #private }
ImageCreationProgressMorph >> show: percentComplete [

	| progressWidth |
	progressWidth := self width * percentComplete / 100.
	self barSize: progressWidth.
]

{ #category : #private }
ImageCreationProgressMorph >> update: anAnnouncement [

	| completionPercentage |
	completionPercentage := anAnnouncement completionPercentage.
	self contents: completionPercentage asString.
	completionPercentage = 100 ifTrue: [ self unsubscribe ].
	
]
