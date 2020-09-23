"
I represent electronic documents in a domain-centered, file system agnostic way.

### Responsibilities
- know where the file came from

## Collaborators
- ResourceLibrary
"
Class {
	#name : #RlResource,
	#superclass : #Object,
	#instVars : [
		'originalFile',
		'file',
		'source',
		'importTimestamp',
		'metadata'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #'as yet unclassified' }
RlResource class >> allFileExtensions [
	^ self subclasses flatCollect: [ :klass | klass fileExtensions ]
]

{ #category : #accessing }
RlResource class >> exampleSupportFolder [
	^ BaselineOfResourcesLive exampleSupportFolder
]

{ #category : #'file types' }
RlResource class >> fileExtensions [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
RlResource class >> newClass: aSymbol forExtensions: aCollection [
	"self newClass: #RlCsvFile forExtensions: #('csv')"
	| newClass fileExtensionsMethod targetPackage |
	targetPackage := 'ResourcesLive-Core'. "Was `self package name`, but evaluating the method comment from Nautilus puts newClass in wrong category (one level too high)"
	newClass := RlResource subclass: aSymbol
			instanceVariableNames: ''
			classVariableNames: ''
			package: targetPackage.
	fileExtensionsMethod := 'fileExtensions
	^ ', aCollection asArray asString.
	newClass class compile: fileExtensionsMethod classified: 'accessing'.
	^ newClass
]

{ #category : #'instance creation' }
RlResource class >> on: file [
	| class |
	class := self allSubclasses
		detect: [ :e | e fileExtensions includes: file extension ]
		ifNone: [ self ].
	^ class new
		file: file;
		yourself.
]

{ #category : #converting }
RlResource >> asFileReference [
	^ self file
]

{ #category : #'*ResourcesLive-Morphic' }
RlResource >> asMorph [
	
	| morph openButton builder controls |
	builder := UITheme builder.
	self flag: 'Looks like we were using LivingCode here'.
	morph := "UserObject"Morph new
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		yourself.
	openButton := builder newButtonFor: self action: #open label: 'Open file' help: ''.
"	pauseButton := builder newButtonFor: self action: #pause label: 'Pause' help: ''."
	controls := builder newRow: { openButton }.
	morph addMorph: controls.
	^ morph.
]

{ #category : #converting }
RlResource >> asRlResource [
	^ self
]

{ #category : #magritte }
RlResource >> descriptionOpen [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #open;
		yourself
]

{ #category : #magritte }
RlResource >> descriptionPreview [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #preview;
		yourself
]

{ #category : #magritte }
RlResource >> descriptionShowInFinder [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #showInFinder;
		yourself
]

{ #category : #'as yet unclassified' }
RlResource >> ensureFileCopiedInto: folder asBase: base [
	| reference |
	reference := folder / base, self class fileExtensions first.
	reference exists ifTrue: [ ^ self ].
	self verifiedCopyFileTo: reference
]

{ #category : #'as yet unclassified' }
RlResource >> ensureFileCopiedTo: reference [
	reference exists ifTrue: [ ^ self ].
	self verifiedCopyFileTo: reference
]

{ #category : #accessing }
RlResource >> file [
	^ file
]

{ #category : #accessing }
RlResource >> file: anObject [
	file := anObject
]

{ #category : #convenience }
RlResource >> import [

	RlResourceLibrary uniqueInstance import: self
]

{ #category : #accessing }
RlResource >> importTimestamp [
	^ importTimestamp
]

{ #category : #accessing }
RlResource >> importTimestamp: anObject [
	importTimestamp := anObject
]

{ #category : #accessing }
RlResource >> metadata [
	^ metadata ifNil: [ metadata := OrderedCollection new ]
]

{ #category : #accessing }
RlResource >> metadata: anObject [
	metadata := anObject
]

{ #category : #actions }
RlResource >> moveFileInto: aFolder [
	self moveFileTo: aFolder / self file basename
]

{ #category : #actions }
RlResource >> moveFileTo: reference [
	self file moveTo: reference.
	self file: reference. "This line is needed due to FS bug: https://github.com/pharo-project/pharo/issues/4453"
]

{ #category : #actions }
RlResource >> open [
	file open
]

{ #category : #accessing }
RlResource >> originalFile [
	^ originalFile
]

{ #category : #accessing }
RlResource >> originalFile: anObject [
	originalFile := anObject
]

{ #category : #actions }
RlResource >> preview [
	file preview
]

{ #category : #printing }
RlResource >> printOn: aStream [
	aStream
		nextPutAll: self className;
		nextPut: $(.
	self file ifNotNil: [ :f | aStream nextPutAll: f basename ].
	aStream nextPut: $)
]

{ #category : #actions }
RlResource >> renameFileTo: aString [
	| target |
	target := self file parent / aString.
	self moveFileTo: target
]

{ #category : #private }
RlResource >> setFile: aDirectoryEntryFile [ 

	file := aDirectoryEntryFile.
	^ self.
]

{ #category : #actions }
RlResource >> showInFinder [
	file showInFinder
]

{ #category : #accessing }
RlResource >> source [
	^ source
]

{ #category : #accessing }
RlResource >> source: anObject [
	source := anObject
]

{ #category : #accessing }
RlResource >> subfolder [
	^ subfolder
]

{ #category : #accessing }
RlResource >> subfolder: anObject [
	subfolder := anObject
]

{ #category : #private }
RlResource >> thumbnail [

	| tempFilePath commandTemplate command thumbnail |
	tempFilePath := RlResourceLibrary temporaryFolder fullNameFor: 'thumbnail.jpg'.
	commandTemplate := '/opt/local/bin/gs -dFirstPage=1 -dLastPage=1 -sDEVICE=jpeg -sOutputFile="{1}" -dBATCH -dNOPAUSE -q  "{2}"'.
	command := commandTemplate format: { tempFilePath. file fullName }.
	OSProcess command: command.
	thumbnail := Form fromFileNamed: tempFilePath.
	^ thumbnail 
]

{ #category : #'as yet unclassified' }
RlResource >> verifiedCopyFileTo: reference [
	self file verifiedCopyTo: reference.
	self file: reference.
]

{ #category : #'as yet unclassified' }
RlResource >> verifiedMoveFileTo: reference [
	self file verifiedMoveTo: reference.
	self file: reference.
]
