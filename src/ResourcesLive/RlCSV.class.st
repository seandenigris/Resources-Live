Class {
	#name : #RlCSV,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlCSV class >> fileExtensions [
	^ #('csv')
]

{ #category : #'as yet unclassified' }
RlCSV >> asArraysOfStrings [
	^ self file readStreamDo: [ :str | 
		| r |
		r := NeoCSVReader on: str .
		r upToEnd ].
]

{ #category : #'as yet unclassified' }
RlCSV >> newRecordClassNamed: aSymbol inPackage: packageName [
	| reader fieldNames |
	self flag: 'Seems incomplete; are fields supposed to be set up automatically?'.
	reader := NeoCSVReader on: self file readStream.
	fieldNames := reader readHeader.
	Object subclass: aSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	package: packageName
]
