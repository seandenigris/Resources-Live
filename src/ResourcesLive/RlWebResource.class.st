Class {
	#name : #RlWebResource,
	#superclass : #RlResource,
	#instVars : [
		'description'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlWebResource class >> fileExtensions [
	^ #()
]

{ #category : #accessing }
RlWebResource >> citation [
	^ QuWebCitation new
		source: self
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
		print: self source
]

{ #category : #importing }
RlWebResource >> rlImportInto: aRlResourceLibrary [
	
	self importTimestamp: DateAndTime rlImportTimestamp.
	aRlResourceLibrary resources add: self.
	
	"Implmentation note: cobbled together from RlInPlaceImportStrategy>>#import"
]
