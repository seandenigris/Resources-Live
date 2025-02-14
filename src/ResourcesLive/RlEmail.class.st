"
An eml file (aka mhtml) is described [here](https://en.wikipedia.org/wiki/MHTML)
"
Class {
	#name : #RlEmail,
	#superclass : #RlResource,
	#instVars : [
		'timestamp',
		'displayString',
		'date',
		'attachments'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #importing }
RlEmail class >> allFromMailClientSelectionImport [

	^ Smalltalk tools mailClient new selectedMessagesImport
]

{ #category : #utilities }
RlEmail class >> downloadFolder: remoteFolder from: server as: user [
	
	| rootFolder commandTemplate command uniqueMessages allMessages |
	rootFolder := FileLocator home / 'Downloads' / 'Email Archive'.
	commandTemplate := 'cd "{rootFolder}"; python dump-imap.py -s {server} -u {user} -r "{remoteFolder}"'.
	command := commandTemplate format: { 
		#rootFolder -> rootFolder fullName.
		#server -> server.
		#user -> user.
		#remoteFolder -> remoteFolder } asDictionary.
	LibC system: command.
	uniqueMessages := PluggableSet new
		equalBlock: [ :a :b | a isMD5Equal: b ];
		hashBlock: [ :f | f binaryReadStreamDo: [ :str | (MD5 hashStream: str) hex hash ] ]
		yourself.
	allMessages := (rootFolder / 'Downloads' / remoteFolder) filesMatching: '*.eml'.
	uniqueMessages addAll: allMessages.
	(allMessages difference: uniqueMessages) do: #delete.
	self renameFilesIn: rootFolder / 'Downloads' / remoteFolder
]

{ #category : #accessing }
RlEmail class >> fileExtensions [
	^ #('eml')
]

{ #category : #utilities }
RlEmail class >> importDownloadFolderNamed: folderName [
	| folder archiveRootFolder emails |
	folder := FileLocator home / 'Downloads' / 'Email Archive' / 'Downloads' / folderName.
	archiveRootFolder := FileLocator home / 'Downloads' / 'Email Archive' / 'Archive'.
	emails := (folder filesMatching: '*.eml') collect: [ :file | RlEmail on: file ].
	emails do: [ :e | e metadata add: folderName ].
	emails
		collect: [ :e | 
			| targetFolder target |
			targetFolder := archiveRootFolder / e timestamp year asString.
			target := targetFolder / e file basename.
			e file verifiedMoveTo: target.
			e file: target ].
	emails do: [ :e | 
		RlResourceLibrary uniqueInstance import
	resourceable: e;
	strategy: RlInPlaceImportStrategy;
	execute ].
	^ RlResourceLibrary uniqueInstance resources select: [ :e | e metadata includes: folderName ]
]

{ #category : #utilities }
RlEmail class >> renameFilesIn: folder [
	| filesToRename email |
	filesToRename := folder files
		select: [ :f | f base isAllDigits and: [ f extension = 'eml' ] ].
	filesToRename
		do: [ :file | 
			email := RlEmail on: file.
			[ file verifiedMoveTo: folder / email properFilename ]
				on: FileExists
				do: [ :e | 
					| n uniqueName |
					n := e reference asFileReference.
					uniqueName := n base , (Time now asString select: #isDigit) , '_copy.eml'.
					(file isMD5Equal: n)
						ifTrue: [ file moveTo: (n parent / 'Duplicates') ensureCreateDirectory / uniqueName ]
						ifFalse: [ file verifiedMoveTo: n parent / uniqueName ] ] ].
	^ folder filesMatching: '*_copy.eml'
]

{ #category : #scripts }
RlEmail class >> verifyProperFiling [
	<script>
	| misfiled |
	misfiled := RlResourceLibrary uniqueInstance resources select: [ :e | (e isKindOf: self) and: [ e file parent base ~= 'Read_Review' and: [e file parent base ~= ('20', (e file base first: 2)) ] ] ].
	misfiled ifNotEmpty: [ self error: 'Found misfiled emails!' ]
]

{ #category : #'as yet unclassified' }
RlEmail >> attachmentRefreshFrom: attachmentPart [

	| tmpFile resource |
	tmpFile := Tempfile named: attachmentPart name.
	
	self attachmentsBasic
		detect: [ :att | att file basename = attachmentPart name ]
		ifFound: [ :att | resource := att ]
		ifNone: [ 
			resource := tmpFile asRlResource
				source: self;
				yourself.
			self attachmentsBasic add: resource ].
				
	resource file ifExists: [ ^ self ].
	
	attachmentPart body saveToFile: tmpFile fullName.
]

{ #category : #'as yet unclassified' }
RlEmail >> attachments [

	self mailMessage attachmentParts do: [ :part |
		self attachmentRefreshFrom: part ].
			
	^ self attachmentsBasic
]

{ #category : #'as yet unclassified' }
RlEmail >> attachmentsBasic [

	^ attachments ifNil: [ attachments := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
RlEmail >> attachmentsGtViewFor: aView [
	<gtView>
	
	self mailMessage attachmentParts ifEmpty: [ ^ aView empty ].
	
	^ aView list
		title: 'Attachments';
		priority: 35;
		items: [ self attachments ]
]

{ #category : #'GT Views' }
RlEmail >> contentsGtViewFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Message' translated;
		priority: 25;
		object: [ self mailMessage ];
		view: #bodyTextGtViewFor:;
		yourself
]

{ #category : #accessing }
RlEmail >> date [
	date ifNotNil: [ ^ date ].
	
	^ self mailMessage ifNotNil: [ :mm | 
		"Adapted from MailMessage>>#date"
		date := Date fromSeconds: mm time + (Date year: 1980 day: 1 ) asSeconds ]
]

{ #category : #accessing }
RlEmail >> displayStringOn: aStream [

	| msg |
	displayString ifNotNil: [ 
		aStream nextPutAll: displayString.
		^ self ].
	
	self file exists ifFalse: [ ^ 'Email - file does not exist' ].
	
	[ 
		msg := self mailMessage.
		self timestamp ifNotNil: [ :stamp |
			aStream 
				nextPutAll: stamp asDate yyyymmdd;
				space;
				nextPutAll: stamp asTime print24 ].
		aStream
			nextPutAll: ' [';
			nextPutAll: msg from;
			nextPutAll: '] ';
			nextPutAll: msg subject withBlanksCondensed 
	]
		on: Error
		do: [ ].
		
	displayString := aStream contents.
]

{ #category : #'GT Views' }
RlEmail >> fieldsGtViewFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Fields' translated;
		priority: 30;
		object: [ self mailMessage ];
		view: #fieldsGtViewFor:;
		yourself
]

{ #category : #accessing }
RlEmail >> mailMessage [
	| contents eml |
	eml := self file.
	eml exists ifFalse: [ ^ nil ].
	
	contents := eml readStreamEncoded: #iso88592 do: [ :str |
		str encoder beLenient. 
		str upToEnd ].
	^ MailMessage fromRfc822: contents
]

{ #category : #'as yet unclassified' }
RlEmail >> messageID [

	^ self mailMessage 
		fieldNamed: 'message-id' 
		ifPresent: #mainValue 
		ifAbsent: [ nil ]
]

{ #category : #printing }
RlEmail >> printOn: aStream [
	aStream
		nextPutAll: 'Email ';
		nextPut: $(;
		nextPutAll: self displayString;
		nextPut: $)
]

{ #category : #accessing }
RlEmail >> properFilename [
	| extension basename |
	extension := '.eml'.
	basename := self displayString collect: [ :c | (#($.$ ) includes: c) ifFalse: [ c ] ifTrue: [ $_ ] ].
	^ (basename, extension) asFilename
]

{ #category : #accessing }
RlEmail >> recipients [

	^ MailAddressParser addressesIn: self mailMessage to.
]

{ #category : #'as yet unclassified' }
RlEmail >> source [

	^ self mailMessage text
]

{ #category : #'GT Views' }
RlEmail >> sourceGtViewFor: aView [
	<gtView>
	
	^ aView forward
		title: 'Source' translated;
		priority: 30;
		object: [ self mailMessage ];
		view: #sourceGtViewFor:;
		yourself
]

{ #category : #accessing }
RlEmail >> subject [

	^ self
		propertyAt: #subjectCache
		ifAbsentPut: [ self mailMessage subject ]
]

{ #category : #accessing }
RlEmail >> timestamp [

	^ self
		propertyAt: #timestampCache
		ifAbsentPut: [ self mailMessage timestamp ]
]

{ #category : #accessing }
RlEmail >> timestamp: anObject [
	"We currently need the ability to manually set do to GH Issue #18"
	timestamp := anObject
]
