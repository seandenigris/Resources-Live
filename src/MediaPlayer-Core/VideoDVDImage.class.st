"
I am a disk image of a video DVD (a .dmg file). I am not synced with the system, so I am only accurate if my underlying file is not manipulated outside of Smalltalk e.g. by unmounting via the command line.
"
Class {
	#name : #VideoDVDImage,
	#superclass : #Object,
	#instVars : [
		'file',
		'deviceFile',
		'mountPoint',
		'diskutilInfo'
	],
	#category : #'MediaPlayer-Core-Files'
}

{ #category : #'instance creation' }
VideoDVDImage class >> on: anFSReference [

	^ self new setFile: anFSReference.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> convertToMP4 [

	| mountedImage |
	mountedImage := self mount.
	^ (PipeableOSProcess command: 'HandBrakeCLI -e x264 -q 20 -i ', mountedImage mountPoint fullName, ' -o Desktop/RWR_DAYGAME.mp4') output.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> diskutilInfo [

	^ diskutilInfo ifNil: [ | command alreadyMounted |
		alreadyMounted := self isMounted.
		alreadyMounted ifFalse: [ self mount ].
		command := Diskutil informationAbout: self mountPoint.
		diskutilInfo := command execute.
		alreadyMounted ifFalse: [ self unmount ].
		diskutilInfo ].
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> isMounted [

	^ MacSystem local mountedDiskImages.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> isPlaying [

	^ self player isPlaying.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> mount [

	^ MacSystem local mount: file.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> mountPoint [

	^ mountPoint.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> pause [

	self player pause.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> play [

	self isMounted ifFalse: [ self mount ].
	self player play: self mountPoint.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> player [

	^ DVDPlayer reference.
]

{ #category : #private }
VideoDVDImage >> setFile: anFSReference [

	file := anFSReference.
	^ self.
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> sizeInBytes [

	self diskutilInfo 
]

{ #category : #'as yet unclassified' }
VideoDVDImage >> unmount [

	Hdiutil eject: deviceFile.
]
