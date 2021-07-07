Class {
	#name : #DiskImageStatus,
	#superclass : #Announcement,
	#instVars : [
		'completionPercentage'
	],
	#category : #'MediaPlayer-Core-Support'
}

{ #category : #'as yet unclassified' }
DiskImageStatus class >> completionPercentage: aNumber [

	^ self new setCompletionPercentage: aNumber.
]

{ #category : #'as yet unclassified' }
DiskImageStatus >> completionPercentage [

	^ completionPercentage.
]

{ #category : #'as yet unclassified' }
DiskImageStatus >> setCompletionPercentage: aNumber [

	completionPercentage := aNumber.
	^ self.
]
