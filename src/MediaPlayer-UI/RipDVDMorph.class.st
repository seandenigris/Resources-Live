Class {
	#name : #RipDVDMorph,
	#superclass : #Morph,
	#instVars : [
		'completionPercentage',
		'shouldCancel',
		'progressMorph'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
RipDVDMorph class >> on: ripper [

	^ self new setRipper: ripper.
]

{ #category : #'as yet unclassified' }
RipDVDMorph >> completionPercentage: aNumber [

	progressMorph show: aNumber.
]

{ #category : #'as yet unclassified' }
RipDVDMorph >> setRipper: ripper [

	| cancelButton builder |
	completionPercentage := 0.
	self
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight;
		cellInset: 10;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color transparent.
	builder := UITheme builder.
	progressMorph := ImageCreationProgressMorph new.
	cancelButton := builder newButtonFor: ripper action: #cancel label: 'x' help: 'Cancel ripping'.
	self
		addMorphBack: progressMorph;
		addMorphBack: cancelButton.
	ripper on: RipProgress do: [ :a | self completionPercentage: a completionPercentage ].
	ripper on: CancelRip do: [ :a | self cancel ].
	^ self.
]
