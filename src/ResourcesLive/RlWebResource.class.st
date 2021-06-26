Class {
	#name : #RlWebResource,
	#superclass : #Object,
	#instVars : [
		'url',
		'description'
	],
	#category : #'ResourcesLive-Non-File'
}

{ #category : #'file types' }
RlWebResource class >> fileExtensions [
	^ #()
]

{ #category : #accessing }
RlWebResource >> citation [
	^ QuWebCitation new
		source: self url
		yourself
]

{ #category : #accessing }
RlWebResource >> description [
	^ description
]

{ #category : #accessing }
RlWebResource >> description: anObject [
	description := anObject
]

{ #category : #Magritte }
RlWebResource >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
			accessor: #description;
			label: 'Description';
			priority: 100;
			default: '';
			beRequired;
			yourself
]

{ #category : #accessing }
RlWebResource >> printOn: aStream [
	aStream
		nextPutAll: self description;
		nextPutAll: ' @ ';
		print: self url
]

{ #category : #importing }
RlWebResource >> rlImportInto: aRlResourceLibrary [
	
	self importTimestamp: DateAndTime rlImportTimestamp.
	aRlResourceLibrary resources add: self.
	
	"Implmentation note: cobbled together from RlInPlaceImportStrategy>>#import"
]

{ #category : #accessing }
RlWebResource >> url [
	^ url
]

{ #category : #accessing }
RlWebResource >> url: anObject [
	url := anObject
]
