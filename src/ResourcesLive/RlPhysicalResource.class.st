Class {
	#name : #RlPhysicalResource,
	#superclass : #RlResource,
	#instVars : [
		'description',
		'location'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlPhysicalResource class >> fileExtensions [
	^ #()
]

{ #category : #accessing }
RlPhysicalResource >> description [
	^ description
]

{ #category : #accessing }
RlPhysicalResource >> description: anObject [
	description := anObject
]

{ #category : #Magritte }
RlPhysicalResource >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
			accessor: #description;
			label: 'Description';
			priority: 100;
			default: '';
			beRequired;
			yourself
]

{ #category : #Magritte }
RlPhysicalResource >> descriptionLocation [
	<magritteDescription>
	^ MAStringDescription new
			accessor: #location;
			label: 'Location';
			priority: 200;
			default: '';
			beRequired;
			yourself
]

{ #category : #accessing }
RlPhysicalResource >> location [
	^ location
]

{ #category : #accessing }
RlPhysicalResource >> location: anObject [
	location := anObject
]

{ #category : #printing }
RlPhysicalResource >> printOn: aStream [
	aStream
		nextPutAll: self description;
		nextPutAll: ' @ ';
		nextPutAll: self location
]
