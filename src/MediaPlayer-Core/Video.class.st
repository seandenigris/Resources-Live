Class {
	#name : #Video,
	#superclass : #Object,
	#traits : 'RlTPlayable',
	#classTraits : 'RlTPlayable classTrait',
	#instVars : [
		'file',
		'clips',
		'title',
		'series'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #'as yet unclassified' }
Video class >> at: anFSReference [

	^ self new setFile: anFSReference.
]

{ #category : #'as yet unclassified' }
Video class >> on: anFSReference [

	^ self new setFile: anFSReference.
]

{ #category : #'as yet unclassified' }
Video >> = aVideo [

	^ self file = aVideo file.
]

{ #category : #'as yet unclassified' }
Video >> addClip: aVideoClip [ 

	clips add: aVideoClip.
]

{ #category : #'as yet unclassified' }
Video >> clips [

	^ clips.
]

{ #category : #'as yet unclassified' }
Video >> file [

	^ file.
]

{ #category : #'as yet unclassified' }
Video >> hash [

	^ self file hash.
]

{ #category : #'as yet unclassified' }
Video >> initialize [

	clips := OrderedCollection new.
	title := ''.
]

{ #category : #playing }
Video >> play [
	
	self player open: file.
	self player play.
]

{ #category : #'as yet unclassified' }
Video >> player [

	^ CwQuickTime reference.
]

{ #category : #playing }
Video >> position [

	^ self player position.
]

{ #category : #playing }
Video >> position: aDuration [

	self player position: aDuration.
]

{ #category : #playing }
Video >> printOn: aStream [

	aStream nextPutAll: self file basename, ' in ', self file parent fullName.
]

{ #category : #'as yet unclassified' }
Video >> series [

	^ series.
]

{ #category : #'as yet unclassified' }
Video >> series: aString [ 

	series := aString.
]

{ #category : #private }
Video >> setFile: aDirectoryEntryFile [ 

	file := aDirectoryEntryFile.
	^ self.
]

{ #category : #'as yet unclassified' }
Video >> title [

	^ title.
]

{ #category : #'as yet unclassified' }
Video >> title: aString [ 

	title := aString.
]
