Class {
	#name : #CreateDiskImageMorph,
	#superclass : #Morph,
	#instVars : [
		'completionPercentage',
		'shouldCancel',
		'progressMorph'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
CreateDiskImageMorph class >> on: convertibleToDiskImage [

	^ self new executeOn: convertibleToDiskImage.
]

{ #category : #'as yet unclassified' }
CreateDiskImageMorph >> cancel [

	shouldCancel := true.
	self delete.
]

{ #category : #'as yet unclassified' }
CreateDiskImageMorph >> completionPercentage: aNumber [

	progressMorph show: aNumber.
]

{ #category : #'as yet unclassified' }
CreateDiskImageMorph >> executeOn: convertibleToDiskImage [

	| cancelButton builder contents |
	completionPercentage := 0.
	shouldCancel := false.
	self
		layoutPolicy: TableLayout new;
		listDirection: #leftToRight;
		cellInset: 10;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color transparent.
	builder := UITheme builder.
	progressMorph := ImageCreationProgressMorph new.
	cancelButton := builder newButtonFor: self action: #cancel label: 'x' help: 'Cancel caching'.
	[ convertibleToDiskImage cacheUpdating: self ] forkAt: Processor userBackgroundPriority.
	self
		addMorphBack: progressMorph;
		addMorphBack: cancelButton.
	^ self.
]

{ #category : #'as yet unclassified' }
CreateDiskImageMorph >> setModel: convertibleToDiskImage [

	| cancelButton builder contents |
	completionPercentage := 0.
	shouldCancel := false.
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		color: Color transparent.
	builder := UITheme builder.
	progressMorph := ImageCreationProgressMorph new center: self center.
	cancelButton := builder newButtonFor: self action: #cancel label: 'x' help: 'Cancel caching'.
	contents := builder newRow: { progressMorph. cancelButton }.
	[ convertibleToDiskImage cacheUpdating: self ] forkAt: Processor userBackgroundPriority.
	self addMorph: contents.
	^ self.
]

{ #category : #'as yet unclassified' }
CreateDiskImageMorph >> shouldCancel [

	^ shouldCancel.
]
