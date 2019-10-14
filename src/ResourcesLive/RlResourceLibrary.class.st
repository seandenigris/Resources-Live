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
	#category : 'ResourcesLive-Core'
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

	^ (ResourcesLiveDB backupDirectoryParent / 'Library') ensureCreateDirectory.
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

{ #category : #deleting }
RlResourceLibrary >> delete: resource [
	self remove: resource.
	resource file delete
]

{ #category : #deleting }
RlResourceLibrary >> deleteAll [
	self resources do: [ :e | e file delete ].
	self folder delete
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
RlResourceLibrary >> ensureResourceForUrl: aUrl [
	^ self resources
		detect: [ :r | r source equals: aUrl ]
		ifNone: [ 
			| preDownload toImport resource |
			preDownload := self inbox / aUrl file.
			toImport := preDownload exists
				ifTrue: [ preDownload ]
				ifFalse: [ aUrl ].
			resource := self import: toImport.
			resource
				source: aUrl;
				yourself ]
]

{ #category : #accessing }
RlResourceLibrary >> ensureResourceForUrl: aUrl in: subFolder [
	^ self resources
		detect: [ :r | r source equals: aUrl ]
		ifNone: [ 
			| preDownload toImport resource |
			preDownload := self inbox / aUrl file.
			toImport := preDownload exists
				ifTrue: [ preDownload ]
				ifFalse: [ aUrl ].
			resource := self import: toImport.
			resource
				source: aUrl;
				yourself ]
]

{ #category : #private }
RlResourceLibrary >> folder [
	^ folder ifNil: [ self class folder ]
]

{ #category : #importing }
RlResourceLibrary >> import: resourceable [

	^ self import: resourceable moving: self doesMoveByDefault
]

{ #category : #importing }
RlResourceLibrary >> import: resourceable moving: shouldMove [
	"Either move or copy the resource into the proper location"

	| destinationFile sourceFile resource |
	resource := resourceable asRlResource.
	sourceFile := resource file.
	destinationFile := self locationFor: sourceFile basename.	
	self assert: destinationFile exists not.
	shouldMove
		ifTrue: [	 sourceFile moveTo: destinationFile ]
		ifFalse: [ sourceFile copyTo: destinationFile ].
	resource
		file: destinationFile;
		originalFile: sourceFile asFileReference;
		importTimestamp: DateAndTime now translateToUTC.
	^ resources add: resource.
]

{ #category : #importing }
RlResourceLibrary >> importInPlace: resourceable [
	"Do not move or copy the file"

	| resource |
	resource := resourceable asRlResource.
	resource importTimestamp: DateAndTime now translateToUTC.
	^ resources add: resource.
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
RlResourceLibrary >> locationFor: filename [

	| sameFilename result |
	sameFilename := self folder / filename.
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