"
Examples:
""Import disk images of video DVDs as DVD objects in a MediaLibrary""
dvdDir := FSFilesystem disk root resolve: '/Users/sean/Documents/Squeak Library/Application Files/Real World Rapport'.
MediaLibrary default importDVDDiskImagesFrom: dvdDir
"
Class {
	#name : #MediaLibrary,
	#superclass : #Object,
	#instVars : [
		'collection'
	],
	#classInstVars : [
		'library'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #accessing }
MediaLibrary class >> default [

	^ library ifNil: [ library := self new ].
]

{ #category : #persistence }
MediaLibrary class >> restoreFrom: aMediaLibrary [

	library := aMediaLibrary.
]

{ #category : #persistence }
MediaLibrary class >> spData [

	^ library
]

{ #category : #'as yet unclassified' }
MediaLibrary >> checkIn: aPlayable [

	^ collection
		detect: [ :e | (e isKindOf: aPlayable class) and: [ e = aPlayable ] ]
		ifNone: [ collection add: aPlayable ].
]

{ #category : #'as yet unclassified' }
MediaLibrary >> collection [

	^ collection.
]

{ #category : #'as yet unclassified' }
MediaLibrary >> importDVDDiskImagesFrom: directory [

	| imageFiles |
	imageFiles := directory files select: [ :e | e extension = 'dmg' ].
	imageFiles do: [ :e | | dvd libraryFile |
		libraryFile := Resources library import: e.
		dvd := DVD fromDiskImage: libraryFile.
		self checkIn: dvd ].
]

{ #category : #'as yet unclassified' }
MediaLibrary >> initialize [

	collection := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
MediaLibrary >> videos [

	^ collection select: [ :e | e isKindOf: Video ].
]
