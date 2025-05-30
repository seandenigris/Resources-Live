"
I represent electronic documents in a domain-centered, file system agnostic way.

# Responsibilities

- know where the file came from

# Collaborators

- ResourceLibrary

"
Class {
	#name : #RlResource,
	#superclass : #Object,
	#traits : 'DbTDomainObject',
	#classTraits : 'DbTDomainObject classTrait',
	#instVars : [
		'originalFile',
		'file',
		'source',
		'importTimestamp',
		'metadata',
		'library',
		'csvFile'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlResource class >> allFileExtensions [
	^ self subclasses flatCollect: [ :klass | klass fileExtensions ]
]

{ #category : #testing }
RlResource class >> doesSpecificallyHandle: file [
	^ self allSubclasses anySatisfy: [ :cls | cls isClassFor: file ]
]

{ #category : #accessing }
RlResource class >> extensionForMimeType: aMimeType [

	^ self allSubclasses 
		detect: [ :cls | 
			cls mimeTypes anySatisfy: [ :clsMime |
				clsMime main = aMimeType main 
					and: [ clsMime sub = aMimeType sub ] ] ] 
		ifFound: [ :cls | cls fileExtensions first ]
		ifNone: [ nil ]
]

{ #category : #'file types' }
RlResource class >> fileExtensions [
	self subclassResponsibility
]

{ #category : #'instance creation' }
RlResource class >> fromString: aString [
	"Send from the relevent subclass, which will provide a correct extension"

	| destination |
	destination := FileSystem memory / UUIDGenerator next asString36, self fileExtensions first.
	
	destination writeStreamDo: [ :str |
		str nextPutAll: aString ].
		
	^ self on: destination
]

{ #category : #testing }
RlResource class >> isAbstract [
	"We use this class for unknown file extensions, to provide basic functionality"
	^ false
]

{ #category : #testing }
RlResource class >> isClassFor: file [
	^ (self fileExtensions includes: file extension asLowercase) and: [ 
		"This is inefficient, but not sure how to iterate subclasses depth-first. Asked on Discord - Pharo general channel 11/5/2020"
		self allSubclasses noneSatisfy: [ :sc | sc isClassFor: file ] ]
]

{ #category : #'file types' }
RlResource class >> mimeTypes [

	^ {}
]

{ #category : #'code generation' }
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
		detect: [ :e | e isClassFor: file ]
		ifNone: [ self ].
	^ class new
		file: file;
		yourself.
]

{ #category : #'instance creation' }
RlResource class >> onTempCopyOf: aResourceable named: aString [
	"Useful when you want to control the file name precisely, e.g. when copying a template or blank form. NB. it uses a temp file because it's convenient to have the file deleted if the resource is no longer needed and does not get imported into a library"

	| copy |
	copy := Tempfile named: aString.
	aResourceable asRlResource file copyTo: copy.
	^ self on: copy.
]

{ #category : #'instance creation' }
RlResource class >> temp [

	| file |
	file := Tempfile withExtension: self fileExtensions first.
	^ self on: file.
]

{ #category : #accessing }
RlResource class >> typeName [
	^ (self name allButFirst: 'Rl' size) normalizeCamelCase
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

{ #category : #accessing }
RlResource >> cache [

	self
		propertyAt: #cache
		ifPresent: [ :val |
			val ifNotNil: [ ^ val ] ].
	
	^ self
		propertyAt: #cache
		put: RlCache new.
		
	"Implementation note: the logic is a bit convoluted because RlCache replaces itself with nil during Fuel serialization, so we have to account for nil as will as non-nil and missing key scenarios. If the cache was stored as an inst var, this would be much cleaner at the cost of an inst var that may or may not be used much"
]

{ #category : #accessing }
RlResource >> cache: anRlCache [

	^ self
		propertyAt: #cache
		putRemovingNil: anRlCache
]

{ #category : #accessing }
RlResource >> contents [
	^ self file contents
]

{ #category : #accessing }
RlResource >> contentsGtViewFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Contents';
		priority: 50;
		object: [ self file ];
		view: #gtContentsFor:;
		yourself
]

{ #category : #accessing }
RlResource >> delete [
	self library ifNotNil: [ self removeFromLibrary ].
	self file deleteAll.
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

{ #category : #actions }
RlResource >> fileCopyTo: aFileReference [

	| target |
	target := aFileReference isDirectory
		ifTrue: [ aFileReference / self file basename ]
		ifFalse: [ aFileReference ].

	self file copyTo: target
]

{ #category : #actions }
RlResource >> fileRenameTo: basenameString [

	self moveFileTo: self file parent / basenameString
]

{ #category : #convenience }
RlResource >> import [
	RlResourceLibrary uniqueInstance import: self
]

{ #category : #accessing }
RlResource >> importDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		gtIcon: BrGlamorousVectorIcons down;
		comment: 'Import into Singleton Library';
		action: #import;
		enableBlock: [ :res | res library isNil ];
		yourself
]

{ #category : #accessing }
RlResource >> importTimestamp [
	^ importTimestamp
]

{ #category : #accessing }
RlResource >> importTimestamp: aDateAndTime [
	importTimestamp := aDateAndTime translateToUTC
]

{ #category : #accessing }
RlResource >> initialize [
	super initialize.
	self ensureUUID
]

{ #category : #accessing }
RlResource >> library [

	^ library
]

{ #category : #accessing }
RlResource >> library: anObject [

	library := anObject
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

{ #category : #accessing }
RlResource >> name [
	^ self propertyAt: #name ifAbsent: [ ^ nil ]
]

{ #category : #accessing }
RlResource >> name: aString [
	^ self propertyAt: #name putRemovingNil: aString
]

{ #category : #accessing }
RlResource >> nameDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		accessor: #name;
		priority: 400;
		yourself
]

{ #category : #actions }
RlResource >> open [
	self file peOpen
]

{ #category : #accessing }
RlResource >> openDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		gtIcon: BrGlamorousVectorIcons playinspect;
		action: #open;
		yourself
]

{ #category : #accessing }
RlResource >> openWith: application [
	self file suOpenWith: application
]

{ #category : #accessing }
RlResource >> originalFile [
	^ originalFile
]

{ #category : #accessing }
RlResource >> originalFile: anObject [
	originalFile := anObject
]

{ #category : #accessing }
RlResource >> pathGtViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Path';
		priority: 35;
		object: [ self file ];
		view: #gtPathFor:
]

{ #category : #'as yet unclassified' }
RlResource >> postCopy [

	| tf |
	super postCopy.
	
	self postCopyDbDomainObject.
	
	tf := Tempfile named: self file basename.
	self fileCopyTo: tf.
	self file: tf.
	self library ifNotNil: [ :lib | lib import: self ].
]

{ #category : #actions }
RlResource >> preview [
	self file preview
]

{ #category : #magritte }
RlResource >> previewDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #preview;
		yourself
]

{ #category : #accessing }
RlResource >> previewGtViewFor: aView [
	"<gtView>"
	
	^ aView forward
		title: 'Preview';
		priority: 25;
		object: [ self file ];
		view: #previewGtViewFor:;
		yourself
]

{ #category : #printing }
RlResource >> printOn: aStream [
	aStream
		nextPutAll: self typeDisplayName;
		nextPut: $(.
	self file ifNotNil: [ :f | aStream nextPutAll: f basename ].
	aStream nextPut: $)
]

{ #category : #accessing }
RlResource >> removeFromLibrary [
	self library remove: self.
	self library: nil.
]

{ #category : #accessing }
RlResource >> resourceClass: aClass [

	| newObject shouldMoveFile fileDestination |
	newObject := aClass newFrom: self.
	self becomeForward: newObject.
	
	shouldMoveFile := self library isNotNil and: [ self library folder contains: self file ].
	
	shouldMoveFile ifFalse: [ ^ self ].
	
	fileDestination := self library locationFor: self in: Path workingDirectory.
	self moveFileTo: fileDestination
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

{ #category : #magritte }
RlResource >> showInFinderDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #showInFinder;
		yourself
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
RlResource >> suOpenWith: application [
	"To be polymorphic with FS"
	
	self openWith: application
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
	tempFilePath := self library temporaryFolder fullNameFor: 'thumbnail.jpg'.
	commandTemplate := '/opt/local/bin/gs -dFirstPage=1 -dLastPage=1 -sDEVICE=jpeg -sOutputFile="{1}" -dBATCH -dNOPAUSE -q  "{2}"'.
	command := commandTemplate format: { tempFilePath. file fullName }.
	"OSProcess command: command."
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
