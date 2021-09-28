Class {
	#name : 'RlInPlaceImportStrategy',
	#superclass : 'Object',
	#instVars : [
		'client'
	],
	#category : 'ResourcesLive-Importing'
}

{ #category : 'accessing' }
RlInPlaceImportStrategy class >> example [
	<gtExample>
	| file library |
	file := Tempfile new.
	library := RlResourceLibrary new.
	library import
		resourceable: file;
		strategy: RlInPlaceImportStrategy;
		execute.
	self assert: library resources atRandom file asFileReference equals: file asFileReference
	
]

{ #category : 'accessing' }
RlInPlaceImportStrategy class >> importFor: aClient [
	^ self new
		client: aClient;
		import
]

{ #category : 'accessing' }
RlInPlaceImportStrategy >> client [
	^ client
]

{ #category : 'accessing' }
RlInPlaceImportStrategy >> client: anObject [
	client := anObject
]

{ #category : 'accessing' }
RlInPlaceImportStrategy >> import [
	| resource |
	resource := self client resourceable asRlResource.
	self prepareResource: resource.
	^ self client library resources add: resource
]

{ #category : 'accessing' }
RlInPlaceImportStrategy >> prepareResource: resource [ 
	resource importTimestamp: DateAndTime rlImportTimestamp.
]
