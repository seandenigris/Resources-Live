"
Frequently, the filesystem is an implementation detail which you should never be forced to deal with directly. For example, you probably don't ''really'' care whether your music is in ==~/Music== or ==~/Documents/Music== or ""a symlink to one of these, but physically elsewhere"". The point is: you want to play your music! 

I relieve you of the burden of crawling down into this low level, non-user-friendly context - the user equivalent of C - and empower you to think and act in your domain of interest that is represented by these files.

Instead of writing:
[[[language=smalltalk
LibC system: 'afplay ', ('/path/to/song.mp3' asFileReference fullName surroundedBy: '""')
]]]
You can simply write:
[[[language=smalltalk
anMP3 play
]]]
Ahhhhhh...  wasn't that nice?! I feel more relaxed already :)
!Importing
The main entry point is ${method:RlResourceLibrary>>#import:}$ - check out its comment.
"
Class {
	#name : #RlResourceLibrary,
	#superclass : #Object,
	#instVars : [
		'resources',
		'folder',
		'temporaryFolder',
		'doesMoveByDefault',
		'lastID'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #'file services' }
RlResourceLibrary class >> fileReaderServicesForFile: fullName suffix: suffix [
	<fileService>
	^ (RlResource allFileExtensions includes: suffix)
		ifTrue: [ { self serviceImport } ]
		ifFalse: [ {} ].
]

{ #category : #private }
RlResourceLibrary class >> folder [

	| folder |
	self flag: 'workaround Pharo bug resolving during ensureCreateDirectory. Fixed in P9'.
	folder := ResourcesLiveDB backupDirectoryParent / 'Library'.
	folder ensureCreateDirectory.
	^ folder
]

{ #category : #'file services' }
RlResourceLibrary class >> handleDroppedFile: aFileReference [

	| resource |
	resource := self import: aFileReference.
	resource asMorph openInWorld.
]

{ #category : #convenience }
RlResourceLibrary class >> import: aFileReference [

	^ self uniqueInstance import: aFileReference.
]

{ #category : #initialization }
RlResourceLibrary class >> initialize [
	"self initialize"

	self folder ensureCreateDirectory.
	self temporaryFolder ensureCreateDirectory.
	"FolderActions enable."
]

{ #category : #'world menu' }
RlResourceLibrary class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Resources Inspect')
		order: 0.30;
		action: [ self uniqueInstance inspect ];
		icon: (Smalltalk ui icons iconNamed: #toolsIcon). 
]

{ #category : #persistence }
RlResourceLibrary class >> restoreFrom: anObject [
	self uniqueInstance: anObject
]

{ #category : #'file services' }
RlResourceLibrary class >> serviceImport [

	| entry |
	entry := SimpleServiceEntry 
		provider: self
		label: 'Import as resource'
		selector: #handleDroppedFile:
		description: ''
		buttonLabel: 'Import'.
	^ entry
		argumentGetter: [ :fs | fs name asFileReference ];
		yourself
]

{ #category : #persistence }
RlResourceLibrary class >> spData [
	^ self uniqueInstance
]

{ #category : #tokens }
RlResourceLibrary class >> temporary [

	^ self new
		basicFolder: (FileLocator imageDirectory / DateAndTime now asString asFilename) ensureCreateDirectory;
		yourself
]

{ #category : #private }
RlResourceLibrary class >> temporaryFolder [

	^ self folder / 'tmp'.
]

{ #category : #'instance creation' }
RlResourceLibrary class >> uniqueInstance [

	^ UniqueInstance ifNil: [ UniqueInstance := self new ].
]

{ #category : #accessing }
RlResourceLibrary class >> uniqueInstance: anObject [
	UniqueInstance := anObject
]

{ #category : #utilities }
RlResourceLibrary class >> verifyUniqueInstance [
	<script>

	| resources d sourced duplicates  |

	"Find resources from the same source (i.e. URL)"
	resources := RlResourceLibrary uniqueInstance resources.
	d := Dictionary new.
	sourced := resources reject: [ :e | e source isNil ].
	sourced
		do: [ :e | 
			| key |
			key := e source.
			d at: key ifPresent: [ :a | (d at: key) add: e ] ifAbsent: [ d at: key put: (OrderedCollection with: e) ] ].
	duplicates := d values select: [ :col | col size > 1 ].
	
	"Find objects appearing multiple times"
	self assert: resources size = resources asIdentitySet size.
]

{ #category : #private }
RlResourceLibrary >> basicFolder: aFolder [
	"If you want to also move all the resources, send #moveFolder:"
	folder := aFolder
]

{ #category : #utilities }
RlResourceLibrary >> checkForMissingFiles [
	^ self resources reject: [ :e | e file exists ]
]

{ #category : #utilities }
RlResourceLibrary >> checkForOrphans [
	| files orphans |
	files := self folder allFiles.
	orphans := files select: [ :f | self resources noneSatisfy: [ :r | r file resolve = f ] ].
	^ orphans
	"
	Useful snippets for dealing with returned files:
	
	orphans collect: #parent as: Set.
	orphans := orphans reject: [ :e | e basename = '.DS_Store' or: [ f isContainedBy: self folder / 'Orphans' ] ].
	orphans select: [ :e | e parent resolve = interestingDirectoryReference ].
	problems do: [ :e | e moveTo: self folder / 'Orphans' ]
	"
]

{ #category : #accessing }
RlResourceLibrary >> clean [
	self shouldBeImplemented.
	"This is a stub for future development. The idea here is that there could be different rules or policies to save disk space e.g. compress certain files/types, move to external storage, etc. Here are a list of possible avenues:
		- Deprecated Launcher templates. The only obvious use case for having these around, beyond one or two for each platform/major-version, is to chase bugs i.e. search through successive prior versions until you find one without a bug. I can't think of a time when this was urgent, and in fact it happens rarely enough that I can't even remember the last time I had to do this. Even then, one *could probably* just download them again. Also, the older they are, the less relevant e.g. it might make sense to have a bunch for the actively developed Pharo version, but P8? P7?..."
]

{ #category : #accessing }
RlResourceLibrary >> defaultImportStrategy [
	^ RlMoveImportStrategy
]

{ #category : #deleting }
RlResourceLibrary >> delete: resource [
	self remove: resource.
	resource file delete
]

{ #category : #deleting }
RlResourceLibrary >> deleteAll [
	self resources do: [ :e | e file delete ].
	self folder delete.
	resources removeAll
]

{ #category : #magritte }
RlResourceLibrary >> descriptionResources [
	<magritteDescription>
	<gtInspectorPresentationOrder: 10>
		
	^ MAToManyRelationDescription new
			accessor: #resources;
			label: 'Resources';
			priority: 100;
			default: OrderedCollection new; "no reason for an OC specifically, except it already is; via #initialize"
			"classes: { RlEmail };"
			glmPresentation: #list;
			yourself
]

{ #category : #importing }
RlResourceLibrary >> doesMoveByDefault [
	^ doesMoveByDefault ifNil: [ true ]
]

{ #category : #importing }
RlResourceLibrary >> doesMoveByDefault: aBoolean [
	doesMoveByDefault := aBoolean
]

{ #category : #accessing }
RlResourceLibrary >> ensureResourceForUrl: aUrlOrCommand [
"Questions:
	- What does it do if it finds the resource, but in a different location, and is using a move strategy? It could be dangerous to just move it out from underneath someone else
"

	| url |
	self flag: 'maybe the argument has to be a command because how else would we treat predownloads consistently?'.
	url := aUrlOrCommand asUrl.
	^ self resources
		detect: [ :r | r source equals: url ]
		ifNone: [ 
			| preDownload toImport resource |
			preDownload := self inbox / url rlFilename.
			toImport := preDownload exists
				ifTrue: [ aUrlOrCommand copy resourceable: preDownload; yourself ]
				ifFalse: [ aUrlOrCommand ].
			resource := self import: toImport.
			resource
				source: url;
				yourself ]
]

{ #category : #private }
RlResourceLibrary >> folder [
	^ folder ifNil: [ self class folder ]
]

{ #category : #accessing }
RlResourceLibrary >> gtViewResourcesOn: aView [
	<gtView>
	^ aView list
		title: 'Resources' translated;
		priority: 1;
		items: [ self resources ]
]

{ #category : #importing }
RlResourceLibrary >> import [
	"Return a command for importing into this library"

	^ RlLibraryImport new
		library: self;
		yourself
]

{ #category : #convencience }
RlResourceLibrary >> import: anObject [
	"For the simplest case, when you don't care where the file ends up living on disk, you can just pass a file reference. For more control, pass a command object; RlLibraryImport is built in (see class comment) or define your own"
	self flag: 'Now that we have #import that returns a command object, not sure we need this to take anything other than a resource as an argument, but maybe it''s important to allow the resource to customize its own import?'.
	^ anObject rlImportInto: self
]

{ #category : #importing }
RlResourceLibrary >> importAll: aCollection [
	"See #import: comment"

	aCollection do: [ :e | self import: e ]
]

{ #category : #accessing }
RlResourceLibrary >> inbox [
	"Store pre-downloaded files here. This is especially useful when they may be hard to download programmatically so that you can e.g. download via a web browser. NB. The file must keep the same name as in the URL, so you can't handle two URLs with the same filename simultaneously"
	^ self folder / 'Inbox'
]

{ #category : #initialization }
RlResourceLibrary >> initialize [

	resources := OrderedCollection new.
]

{ #category : #private }
RlResourceLibrary >> lastID [
	^ lastID ifNil: [ lastID := 0 ]
]

{ #category : #private }
RlResourceLibrary >> lastID: aNumber [
	lastID := aNumber
]

{ #category : #private }
RlResourceLibrary >> locationFor: filename in: location [

	| sameFilename result targetFolder |
	targetFolder := self folder rlAppend: location.
	sameFilename := targetFolder / filename.
	result := sameFilename exists
		ifFalse: [ sameFilename ]
		ifTrue: [ 
			| uniqueBase |
			uniqueBase := self nextID, ' (', sameFilename base, ')'.
			self folder / uniqueBase, sameFilename extension ].
	self assert: result exists not.
	^ result
]

{ #category : #private }
RlResourceLibrary >> moveFolder: aFolder [
	self resources do: [ :e | e moveFileInto: aFolder ].
	self basicFolder: aFolder
]

{ #category : #private }
RlResourceLibrary >> nextID [
	self lastID: self lastID + 1.
	^ self lastID printStringHex
]

{ #category : #deleting }
RlResourceLibrary >> remove: resource [
	self resources remove: resource
]

{ #category : #accessing }
RlResourceLibrary >> resources [
	^ resources
]

{ #category : #private }
RlResourceLibrary >> resources: anObject [
	resources := anObject
]

{ #category : #private }
RlResourceLibrary >> temporaryFolder [

	^ temporaryFolder ifNil: [ self class temporaryFolder ]
]

{ #category : #private }
RlResourceLibrary >> temporaryLocationFor: fileName [

	^ self temporaryFolder / fileName.
]
