Class {
	#name : #RlCSV,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlCSV class >> fileExtensions [
	^ #('csv')
]

{ #category : #accessing }
RlCSV >> asArraysOfStrings [
	^ self neoCSVReaderDo: [ :r | r upToEnd ].
]

{ #category : #accessing }
RlCSV >> asDictionaries [
	"Requires a header, the columns of which will become the dictionary keys"

	^ self neoCSVReaderDo: [ :rdr |
		rdr
			namedColumnsConfiguration;
			upToEnd ].
]

{ #category : #accessing }
RlCSV >> dataFrame [
	^ #DataFrame asClass readFromCsv: self file
]

{ #category : #accessing }
RlCSV >> dataFrameUsingReaderDo: aBlock [
	| reader |
	reader := #DataFrameCsvReader asClass new.
	aBlock cull: reader.
	^ #DataFrame asClass readFrom: self file using: reader.
]

{ #category : #accessing }
RlCSV >> fieldNames [
	^ self neoCSVReaderDo: #readHeader
]

{ #category : #accessing }
RlCSV >> neoCSVReaderDo: aBlock [

	^ self file readStreamDo: [ :str | 
		| r |
		r := NeoCSVReader on: str .
		aBlock value: r ].
]

{ #category : #accessing }
RlCSV >> neoCSVReaderSelect: lineBlock thenDo: aBlock [

	| recordLines cleanInputString |
	recordLines := self file contents lines select: lineBlock.
	cleanInputString := String streamContents: [ :str |
		recordLines
			do: [ :line | str << line ]
			separatedBy: [ str crlf ] ].

	^ cleanInputString readStreamDo: [ :str | 
		| r |
		r := NeoCSVReader on: str .
		aBlock value: r ].
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
