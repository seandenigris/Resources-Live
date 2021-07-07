Class {
	#name : #DVDMorph,
	#superclass : #ImageMorph,
	#instVars : [
		'dvd'
	],
	#category : #'MediaPlayer-UI'
}

{ #category : #'as yet unclassified' }
DVDMorph class >> buildWindowKeymappingsOn: aBuilder [
	<keymap>
	(aBuilder shortcut: #playDVD) 
		category: #DVDPlaying
		default: $p asShortcut
		do: [ :morph :event | morph togglePlayAndPause  ].
	aBuilder attachShortcutCategory: #DVDPlaying to: DVDMorph.
]

{ #category : #'as yet unclassified' }
DVDMorph class >> on: aDVD [

	^ self new setDVD: aDVD.
]

{ #category : #'as yet unclassified' }
DVDMorph class >> openOn: aDVD [

	^ (self on: aDVD) openInWorld.
]

{ #category : #menu }
DVDMorph >> addYellowButtonMenuItemsTo: aMenu event: evt [

	super addYellowButtonMenuItemsTo: aMenu event: evt.
	aMenu
		add: 'Cache to local disk image' translated action: #cache;
		add: 'Rip to mp4' translated action: #rip;
		add: 'Play' translated action: #play;
		add: 'Pause' translated action: #pause.

]

{ #category : #friend }
DVDMorph >> cache [

	| creationMorph |
	creationMorph := CreateDiskImageMorph on: self dvd.
	self addMorph: creationMorph.
	creationMorph center: self center + (0@50).

]

{ #category : #accessing }
DVDMorph >> dvd [

	^ dvd.
]

{ #category : #private }
DVDMorph >> form [

	^ Form fromFileNamed: 'DVD.png'.
]

{ #category : #'event handling' }
DVDMorph >> handlesMouseDown: anEvent [

	^ true.
]

{ #category : #'event handling' }
DVDMorph >> handlesMouseOver: anEvent [

	^ true.
]

{ #category : #'event handling' }
DVDMorph >> mouseDown: anEvent [

	super mouseDown: anEvent.
	anEvent hand waitForClicksOrDrag: self event: anEvent.
]

{ #category : #'event handling' }
DVDMorph >> mouseEnter: anEvent [

	anEvent hand newKeyboardFocus: self.
]

{ #category : #'event handling' }
DVDMorph >> mouseLeave: anEvent [

	anEvent hand newKeyboardFocus: nil.
]

{ #category : #playing }
DVDMorph >> pause [

	dvd pause.
]

{ #category : #playing }
DVDMorph >> play [

	dvd play.
]

{ #category : #'as yet unclassified' }
DVDMorph >> rip [

	| ripper morph |
	ripper := dvd ripper.
	morph := RipDVDMorph on: ripper.
	self addMorph: morph.
	morph center: self center + (0@50).
	ripper execute.
]

{ #category : #private }
DVDMorph >> setDVD: aDVD [ 

	self
		image: self form;
		wantsYellowButtonMenu: true.
	dvd := aDVD.
	shouldCancel := false.
	^ self.
]

{ #category : #'event handling' }
DVDMorph >> startDrag: anEvent [

	anEvent hand grabMorph: self.
]

{ #category : #'event handling' }
DVDMorph >> togglePlayAndPause [

	dvd togglePlayAndPause.
]
