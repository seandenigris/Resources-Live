Class {
	#name : 'RlJSON',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'accessing' }
RlJSON class >> fileExtensions [
	^ #('json')
]

{ #category : 'accessing' }
RlJSON >> asArraysOfStrings [
	^ self neoCSVReaderDo: [ :r | r upToEnd ].
]

{ #category : 'accessing' }
RlJSON >> asDictionaries [

	^ self neoJSONReaderDo: [ :rdr |
		rdr upToEnd ].
]

{ #category : 'accessing' }
RlJSON >> asOrderPreservingDictionaries [
	"Requires a header, the columns of which will become the dictionary keys"

	^ self neoCSVReaderDo: [ :rdr |
		rdr
			namedColumnsConfiguration;
			recordClass: OrderPreservingDictionary;
			upToEnd ].
]

{ #category : 'accessing' }
RlJSON >> dataFrame [
	^ #DataFrame asClass readFromCsv: self file
]

{ #category : 'accessing' }
RlJSON >> dataFrameUsingReaderDo: aBlock [
	| reader |
	reader := #DataFrameCsvReader asClass new.
	aBlock cull: reader.
	^ #DataFrame asClass readFrom: self file using: reader.
]

{ #category : 'accessing' }
RlJSON >> fieldNames [
	^ self neoCSVReaderDo: #readHeader
]

{ #category : 'reading' }
RlJSON >> neoCSVReaderSelect: lineBlock thenDo: aBlock [

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

{ #category : 'writing' }
RlJSON >> neoCSVWriterDo: aBlock [

	^ self file writeStreamDo: [ :str | 
		| r |
		r := NeoCSVWriter on: str .
		aBlock value: r ].
]

{ #category : 'reading' }
RlJSON >> neoJSONReaderDo: aBlock [

	^ self file readStreamDo: [ :str | 
		| r |
		r := NeoJSONReader on: str .
		r propertyNamesAsSymbols: true.
		aBlock 
			value: r ].
]

{ #category : 'as yet unclassified' }
RlJSON >> newRecordClassNamed: aSymbol inPackage: packageName [
	| reader fieldNames |
	self flag: 'Seems incomplete; are fields supposed to be set up automatically?'.
	reader := NeoCSVReader on: self file readStream.
	fieldNames := reader readHeader.
	Object subclass: aSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	package: packageName
]
