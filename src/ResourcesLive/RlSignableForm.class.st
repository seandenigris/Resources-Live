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

{ #category : #'as yet unclassified' }
RlSignableForm >> clientPropertyKey [
	self subclassResponsibility
]

{ #category : #accessing }
RlSignableForm >> form [
	
	form ifNotNil: [ ^ form ].
	
	self formCopyingFile: self blankFormFile. 
	^ form
]

{ #category : #accessing }
RlSignableForm >> form: anRlResource [

	form := anRlResource
]

{ #category : #accessing }
RlSignableForm >> formCopyingFile: aFile [

	| resource |
	resource := self class formClass onTempCopyOf: aFile named: self newFormFilename.
	
	self form: (resource 
		import;
		name: 'Editable Form';
		yourself)
]

{ #category : #accessing }
RlSignableForm >> formDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
		accessor: #form;
		classes: { self class formClass };
		yourself
]

{ #category : #accessing }
RlSignableForm >> newFormFilename [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
RlSignableForm >> save [

	self saveAs: self clientPropertyKey
]

{ #category : #accessing }
RlSignableForm >> saveAs: aSelector [

	self client perform: aSelector asMutator with: self.
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
