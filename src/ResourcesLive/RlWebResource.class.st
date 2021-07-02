Class {
	#name : #RlWebResource,
	#superclass : #MAObject,
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

{ #category : #testing }
RlWebResource class >> isAbstract [
	^ false
]

{ #category : #accessing }
RlWebResource >> citation [
	^ QuWebCitation new
		source: self url
		yourself
]

{ #category : #accessing }
RlWebResource >> description [
	^ self maLazyInstVarUsing: self descriptionDescription
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

{ #category : #accessing }
RlWebResource >> url [
	^ url
]

{ #category : #accessing }
RlWebResource >> url: anObject [
	url := anObject
]
