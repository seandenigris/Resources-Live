"
I am a handler for when a DVD is inserted in the drive. I work in conjunction with an Applescript Digital Hub script. You can read about Digital Hub scripting in """"AppleScript: The Definitive Guide, 2nd Edition"""" Page 465. An initial starting point is the CDs & DVDs pane of System Preferences, but power users should check out the com.apple.digihub preference file for programmatic access.
"
Class {
	#name : #VideoDVDInserted,
	#superclass : #Object,
	#classInstVars : [
		'service'
	],
	#category : #'MediaPlayer-Core-Services'
}

{ #category : #'starting/stopping' }
VideoDVDInserted class >> initialize [

	"service := RestServiceDispatcher instance.
	service
		handle: 'video' with: self new."
]

{ #category : #private }
VideoDVDInserted class >> service [

	^ service ifNil: [ service := SRSHttpRestService new
		mainResource: self new;
		setDebugMode;
		yourself ].
]

{ #category : #'starting/stopping' }
VideoDVDInserted class >> start [

	self service	startOn: 8091.
]

{ #category : #'starting/stopping' }
VideoDVDInserted class >> stop [

	self service	stop.
]

{ #category : #'request methods' }
VideoDVDInserted >> post: aRequest [

	| diskName checkedInDisk |
	diskName := aRequest postFields at: #disk_name.	
	checkedInDisk := MediaLibrary default checkIn: DVD currentlyInDrive.
	checkedInDisk openAsMorph.
	"^ SRSResource new emptyResponse."
]
