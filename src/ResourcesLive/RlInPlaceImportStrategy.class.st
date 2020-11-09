Class {
	#name : #RlInPlaceImportStrategy,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : #'ResourcesLive-Importing'
}

{ #category : #accessing }
RlInPlaceImportStrategy class >> importFor: aClient [
	| resource |
	client := aClient.
	resource := client resourceable asRlResource.
	self prepareResource: resource.
	^ client library resources add: resource
]

{ #category : #accessing }
RlInPlaceImportStrategy >> client [
	^ client
]

{ #category : #accessing }
RlInPlaceImportStrategy >> client: anObject [
	client := anObject
]

{ #category : #accessing }
RlInPlaceImportStrategy >> import [
	| resource |
	resource := self client resourceable asRlResource.
	self prepareResource: resource.
	^ self client library resources add: resource
]

{ #category : #accessing }
RlInPlaceImportStrategy >> prepareResource: resource [ 
	resource importTimestamp: DateAndTime rlImportTimestamp.
]
