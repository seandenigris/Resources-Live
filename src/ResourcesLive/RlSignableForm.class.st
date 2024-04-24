Class {
	#name : #RlSignableForm,
	#superclass : #Object,
	#traits : 'MATPropertyOwner',
	#classTraits : 'MATPropertyOwner classTrait',
	#instVars : [
		'form',
		'signedCopy',
		'client'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #'instance creation' }
RlSignableForm class >> forClient: aClient [

	^ self new
		client: aClient;
		yourself
]

{ #category : #private }
RlSignableForm class >> formClass [
	self subclassResponsibility
]

{ #category : #private }
RlSignableForm >> blankFormFile [
	self subclassResponsibility
]

{ #category : #accessing }
RlSignableForm >> client [
	^ client
]

{ #category : #accessing }
RlSignableForm >> client: anObject [
	client := anObject
]

{ #category : #accessing }
RlSignableForm >> form [
	
	^ form ifNil: [ self formCopyingFile: self blankFormFile. form ]
]

{ #category : #accessing }
RlSignableForm >> form: anRlResource [

	form := anRlResource
]

{ #category : #accessing }
RlSignableForm >> formCopyingFile: aFile [

	| copy resource |
	copy := Tempfile named: self newFormFilename.
	aFile copyTo: copy.
	resource := self class formClass on: copy.
	
	self form: (resource 
		import;
		name: 'Editable Form';
		yourself)
]

{ #category : #accessing }
RlSignableForm >> newFormFilename [
	self subclassResponsibility
]

{ #category : #accessing }
RlSignableForm >> signedCopy [
	^ signedCopy
]

{ #category : #accessing }
RlSignableForm >> signedCopy: anObject [
	signedCopy := anObject
]

{ #category : #accessing }
RlSignableForm >> signedCopyDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
		accessor: #signedCopy;
		priority: 250;
		gtSearchSource: RlResourceLibrary uniqueInstance;
		classes: RlResource withAllSubclasses;
		yourself
]
