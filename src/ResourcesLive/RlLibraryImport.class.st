Class {
	#name : #RlLibraryImport,
	#superclass : #Object,
	#instVars : [
		'resource',
		'library',
		'location',
		'shouldMoveVsCopy'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #private }
RlLibraryImport >> asUrl [
	"Make me polymorphic with URL to simplify importation process for library. In the use case considered (`#ensureResourceForUrl:`), `#resource` will always be a bare URL. It does not seem needed at this time to account for the possibility that it is already `aResource`"
	^ self resource
]

{ #category : #private }
RlLibraryImport >> execute [
	^ self library import: self resource into: self location moving: self shouldMoveVsCopy
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
		print: self resource;
		nextPutAll: ' into ';
		print: self location.
]

{ #category : #accessing }
RlLibraryImport >> resource [
	^ resource
]

{ #category : #accessing }
RlLibraryImport >> resource: anObject [
	resource := anObject
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
