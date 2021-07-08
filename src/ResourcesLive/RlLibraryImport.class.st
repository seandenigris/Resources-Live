"
I am a command which imports files into an {{gtClass:RlResourceLibrary}}. As a convenience, I accept several object types which specify what to import - see {{gtMethod:RlLibraryImport>>#resourceable:}}.  The only other thing you *need* to supply is the {{gtMethod:RlLibraryImport>>#library:|label=library}} I should target. 

I have several other optional arguments that you can set if you need more control for a particular scenario:
- The relative {{gtMethod:RlLibraryImport>>#location:|label=location}} inside the target library's filesystem where the file should be kept. While not at all necessary, there are times when this might be desirable
- The {{gtMethod:RlLibraryImport>>#strategy:|label=strategy}} I should use to bring the file under my control. The built-in options are:
```
RlInPlaceImportStrategy withAllSubclasses
```

"
Class {
	#name : #RlLibraryImport,
	#superclass : #Object,
	#instVars : [
		'library',
		'location',
		'resourceable',
		'strategy'
	],
	#category : #'ResourcesLive-Importing'
}

{ #category : #private }
RlLibraryImport >> asUrl [
	"Make me polymorphic with URL to simplify the importation process for the library. In the use case considered (`#ensureResourceForUrl:`), `#resourceable` will always be a bare URL. It does not seem needed at this time to account for the possibility that it is already `aResource`"
	^ self resourceable
]

{ #category : #private }
RlLibraryImport >> execute [
	^ self strategy importFor: self.
]

{ #category : #accessing }
RlLibraryImport >> library [
	^ library
]

{ #category : #accessing }
RlLibraryImport >> library: anObject [
	library := anObject
]

{ #category : #accessing }
RlLibraryImport >> location [
	^ location ifNil: [ Path workingDirectory ]
]

{ #category : #accessing }
RlLibraryImport >> location: anObject [
	location := anObject
]

{ #category : #printing }
RlLibraryImport >> printOn: aStream [
	aStream
		nextPutAll: 'Import ';
		print: self resourceable;
		nextPutAll: ' into ';
		print: self location.
]

{ #category : #accessing }
RlLibraryImport >> resourceable [
	^ resourceable
]

{ #category : #accessing }
RlLibraryImport >> resourceable: convertibleToResource [
	"convertibleToResource - must respond to #asRlResource, see implementors"
	resourceable := convertibleToResource
]

{ #category : #'api - polymorphism' }
RlLibraryImport >> rlImportInto: aRlResourceLibrary [
	"See method comment in Object (same message)"
	^ self
		library: aRlResourceLibrary;
		execute.
]

{ #category : #accessing }
RlLibraryImport >> strategy [
	^ strategy ifNil: [ self library defaultImportStrategy ]
]

{ #category : #accessing }
RlLibraryImport >> strategy: anObject [
	"See: RlInPlaceImportStrategy withAllSubclasses"
	strategy := anObject
]
