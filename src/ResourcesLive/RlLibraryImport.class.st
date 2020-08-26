"
I am a command which imports files into an ${class:RlResourceLibrary}$. As a convenience, I accept several object types which specify what to import - see ${method:RlLibraryImport>>#resourceable:}$.  The only other thing you ''need'' to supply is the ${method:RlLibraryImport>>#library:|label=library}$ I should target. 

I have several other optional arguments that you can set if you need more control for a particular scenario:
- The relative ${method:RlLibraryImport>>#location:|label=location}$ inside my filesystem where the file should be kept. While not at all necessary, there are times when this might be desirable e.g. 
- The ${method:RlLibraryImport>>#shouldMoveVsCopy|label=strategy}$ (copy or move) I should use to bring the file under my control. Eventually, ""do nothing"" i.e. ""leave the file in place"" will be added, simplifying the library API.
"
Class {
	#name : #RlLibraryImport,
	#superclass : #Object,
	#instVars : [
		'library',
		'location',
		'shouldMoveVsCopy',
		'resourceable'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #private }
RlLibraryImport >> asUrl [
	"Make me polymorphic with URL to simplify the importation process for the library. In the use case considered (`#ensureResourceForUrl:`), `#resourceable` will always be a bare URL. It does not seem needed at this time to account for the possibility that it is already `aResource`"
	^ self resourceable
]

{ #category : #private }
RlLibraryImport >> execute [
	^ self library import: self resourceable into: self location moving: self shouldMoveVsCopy
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

{ #category : #'as yet unclassified' }
RlLibraryImport >> rlImportInto: aRlResourceLibrary [
	"See method comment in Object (same message)"
	^ self
		library: aRlResourceLibrary;
		execute.
]

{ #category : #accessing }
RlLibraryImport >> shouldMoveVsCopy [
	^ shouldMoveVsCopy ifNil: [ self library doesMoveByDefault ]
]

{ #category : #accessing }
RlLibraryImport >> shouldMoveVsCopy: anObject [
	shouldMoveVsCopy := anObject
]
