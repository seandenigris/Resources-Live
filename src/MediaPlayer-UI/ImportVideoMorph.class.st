Class {
	#name : #ImportVideoMorph,
	#superclass : #Object,
	#instVars : [
		'filePath',
		'window',
		'pathWidget'
	],
	#category : #'MediaPlayer-UI-Other'
}

{ #category : #'as yet unclassified' }
ImportVideoMorph class >> open [

	^ self new open.
]

{ #category : #'as yet unclassified' }
ImportVideoMorph >> import [

	| video |
	pathWidget accept.
	video := Video on: filePath contents asFile.
	MediaLibrary default checkIn: video.
	window delete.
]

{ #category : #'as yet unclassified' }
ImportVideoMorph >> initialize [

	super initialize.
	filePath := ValueHolder new.
]

{ #category : #'as yet unclassified' }
ImportVideoMorph >> morph [

	| builder |
	builder := UITheme builder.
	pathWidget := builder newTextEntryFor: filePath
				getText: #contents
				setText: #contents:
				help: ''.
	^ builder newRow: {
			pathWidget.
			builder newButtonFor: self action: #import label: 'Import' help: '' }.
]

{ #category : #'as yet unclassified' }
ImportVideoMorph >> open [

	window := self morph openInWindowLabeled: 'Import video'.
	window extent: 500@150.
]
