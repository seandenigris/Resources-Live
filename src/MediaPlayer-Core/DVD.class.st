Class {
	#name : #DVD,
	#superclass : #OpticalDisk,
	#traits : 'RlTPlayable',
	#classTraits : 'RlTPlayable classTrait',
	#instVars : [
		'observers',
		'sections',
		'notes',
		'drutilStatus',
		'drutilDiscinfo',
		'diskutilInfo',
		'diskImage',
		'videoFile'
	],
	#classVars : [
		'DVDs'
	],
	#category : #'MediaPlayer-Core'
}

{ #category : #'instance creation' }
DVD class >> currentlyInDrive [

	^ self new setInfoFromCurrentDisc.
]

{ #category : #'instance creation' }
DVD class >> fromDiskImage: anFSReference [

	^ self new setDiskImage: anFSReference.
]

{ #category : #'instance creation' }
DVD class >> fromDiskName: aString [ 

	^ self new setTitle: '' diskName: aString.
]

{ #category : #'class initialization' }
DVD class >> initialize [

	DVDs := OrderedCollection  new.
]

{ #category : #playing }
DVD class >> play: titleString for: aMind [ 

	^ (self titled: titleString)
		playFor: aMind;
		yourself.
]

{ #category : #playing }
DVD class >> playCurrent [

	^ self currentDVD
		play;
		yourself.
]

{ #category : #'instance creation' }
DVD class >> rippedTo: aDirectoryEntryFile [

"	^ self new localImage: aDirectoryEntryFile"
]

{ #category : #'instance creation' }
DVD class >> titled: aString [ 

	^ self new setTitle: aString.
]

{ #category : #copying }
DVD >> = aDVD [

	^ self size = aDVD size and: [ self diskName = aDVD diskName ].
]

{ #category : #mind }
DVD >> beObservedBy: aMind [ 

	observers add: aMind.
]

{ #category : #playing }
DVD >> bestFormat [

	videoFile ifNotNil: [ :f | ^ f ].
	(diskImage isKindOf: VideoDVDImage) ifTrue: [ ^ diskImage ].
	self isPresent
		ifTrue: [ DVDPlayer reference play ]
		ifFalse: [ self error: 'Disk not in drive' ].
]

{ #category : #'as yet unclassified' }
DVD >> cacheUpdating: anObject [

	self createDiskImageUpdating: anObject.
]

{ #category : #'as yet unclassified' }
DVD >> cacheUpdating: aBlock cancelIf: cancelPredicate [

	self createDiskImageUpdating: aBlock cancelIf: cancelPredicate.
]

{ #category : #'as yet unclassified' }
DVD >> createDiskImageUpdating: anObject [
	"anObject will be sent status updates"

	| imageFileName |
	imageFileName := self diskName, '.dmg'.
	Resources library importAs: imageFileName after: [ :fileReference |
		CreateDiskImage
			from: self deviceFile
			to: fileReference
			updating: anObject.
		diskImage := fileReference ].
]

{ #category : #'as yet unclassified' }
DVD >> createDiskImageUpdating: aBlock cancelIf: cancelPredicate [

	| imageFileName |
	imageFileName := self diskName, '.dmg'.
	Resources library importAs: imageFileName after: [ :fileReference |
		CreateDiskImage
			from: self deviceFile
			to: fileReference
			updating: aBlock
			cancelIf: cancelPredicate.
		diskImage := fileReference ].
]

{ #category : #private }
DVD >> deviceFile [

	self isMounted ifFalse: [ self error: 'DVD has no device file becuase it''s not mounted' ].
	^ self diskutilInfo deviceFile.
]

{ #category : #private }
DVD >> diskName [

	^ diskName ifNil: [ diskName := self diskutilInfo volumeName ].
]

{ #category : #private }
DVD >> diskutilInfo [

	^ diskutilInfo ifUnknown: [ diskutilInfo := diskImage diskutilInfo ].
]

{ #category : #private }
DVD >> drutilDiscinfo [

	^ drutilDiscinfo.
]

{ #category : #private }
DVD >> drutilStatus [

	^ drutilStatus.
]

{ #category : #copying }
DVD >> hash [

	^ drutilStatus hash + drutilDiscinfo hash + drutilDiscinfo hash.
]

{ #category : #initialization }
DVD >> initialize [

	diskutilInfo := UnknownDiskInfo new.
	drutilStatus := UnknownDiskInfo new.
	drutilDiscinfo := UnknownDiskInfo new.
	diskImage := NoDiskImage new.
	^ self.
]

{ #category : #initialization }
DVD >> initializer [

	observers := OrderedCollection  new.
	sections := OrderedCollection new.
	notes := Note note: 'Notes on ', self title near: 0.
]

{ #category : #'as yet unclassified' }
DVD >> isMounted [

	^ diskImage isMounted or: [ self isInDrive ].
]

{ #category : #'making clips' }
DVD >> markInterestingClip [

	self pause.
	^ MarkInterestingDVDClip from: self.
]

{ #category : #'making clips' }
DVD >> markStartOfSection [

	self pause.
	^ MarkStartOfOpticalDiscSection from: self.
]

{ #category : #private }
DVD >> note: aString [ 

	notes note: aString near: self position.
]

{ #category : #mind }
DVD >> note: informationString asA: typeString [

	self pause.
	self observer consider: informationString asA: typeString.
]

{ #category : #accessing }
DVD >> notes [

	^ notes.
]

{ #category : #mind }
DVD >> observer [

	^ Mind ofSean.
]

{ #category : #'as yet unclassified' }
DVD >> onDiskImageStatusUpdateDo: aBlock [

	self announcer on: DiskImageStatus do: aBlock.
]

{ #category : #playing }
DVD >> pause [

	self bestFormat pause.
]

{ #category : #playing }
DVD >> play [

	self bestFormat play.
]

{ #category : #mind }
DVD >> playFor: aPerson [

	aPerson lookAt: self.
	self play.
]

{ #category : #accessing }
DVD >> playLength [

	^ self player dvdPlayLength.
]

{ #category : #private }
DVD >> player [

	^ self bestFormat player.
]

{ #category : #playing }
DVD >> position [

	^ self player position.
]

{ #category : #playing }
DVD >> position: aDuration [

	self player position: aDuration.
]

{ #category : #private }
DVD >> printOn: aStream [

	aStream nextPutAll: self diskName.
]

{ #category : #private }
DVD >> realDiskutilInfo [

	^ diskutilInfo ifUnknown: [ diskutilInfo := diskImage diskutilInfo ].
]

{ #category : #'as yet unclassified' }
DVD >> ripper [

	^ RipDVD on: self.
]

{ #category : #private }
DVD >> section: aTitleString startsAt: aNumberOfSeconds [

	
	sections add: (DVDClip 
					from: self
					startingAt: aNumberOfSeconds
					andEndingAt: self playLength).
]

{ #category : #accessing }
DVD >> sections [

	^ sections copy.
]

{ #category : #private }
DVD >> setDiskImage: anFSReference [ 

	diskImage := VideoDVDImage on: anFSReference.
	diskutilInfo := diskImage diskutilInfo.
	^ self.
]

{ #category : #private }
DVD >> setInfoFromCurrentDisc [
	"We have no idea what uniquely identifies a disc, so just save everything and we'll parse/filter/whatever when the need arises"
	
	drutilStatus := DrUtil status execute.
	drutilDiscinfo := DrUtil discinfo execute.
	diskutilInfo := (Diskutil informationAbout: drutilStatus deviceFile) execute.
	^ self.
]

{ #category : #private }
DVD >> setTitle: titleString diskName: nameString [

	title := titleString.
	diskName := nameString.
	^ self.
]

{ #category : #copying }
DVD >> size [

	^ self diskutilInfo size.
]

{ #category : #accessing }
DVD >> state [

	^ DVDPlayer reference dvdState.
]

{ #category : #mind }
DVD >> takeNote [

	self pause.
	^ TakeNote on: self.
]

{ #category : #accessing }
DVD >> timeRemaining [

	^ self player timeRemaining.
]

{ #category : #private }
DVD >> title: aString [ 
	"I'm not clear if this method will survive - a title may be a condition of validity, in which case, maybe it's set on instance creation and immutable."
	
	title := aString.
]

{ #category : #'as yet unclassified' }
DVD >> togglePlayAndPause [

	| file |
	file := self bestFormat.
	file isPlaying
		ifTrue: [ file pause ]
		ifFalse: [ file play ].
]

{ #category : #'as yet unclassified' }
DVD >> unsubscribe: anObject [

	self announcer unsubscribe: anObject.
]
