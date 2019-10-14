Class {
	#name : #RlPdfToImageConverter,
	#superclass : #Object,
	#instVars : [
		'inputFile',
		'outputFile',
		'command',
		'somet'
	],
	#classInstVars : [
		'current'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #converting }
RlPdfToImageConverter class >> convert: inputFile to: outputFile [
	self current new convert: inputFile to: outputFile.
]

{ #category : #private }
RlPdfToImageConverter class >> current [
	^ current ifNil: [ self installedConverter ]
]

{ #category : #private }
RlPdfToImageConverter class >> current: aClass [
	current := aClass
]

{ #category : #private }
RlPdfToImageConverter >> command [

	^ self commandTemplate format: {
			(#input -> self inputFile asFileReference fullName).
			(#output -> self outputFile asFileReference fullName) } asDictionary.
]

{ #category : #accessing }
RlPdfToImageConverter >> command: anObject [
	command := anObject
]

{ #category : #private }
RlPdfToImageConverter >> commandTemplate [
	self subclassResponsibility
]

{ #category : #converting }
RlPdfToImageConverter >> convert [
	| p |
	p := PipeableOSProcess waitForCommand: self command.
	self assert: p succeeded
]

{ #category : #converting }
RlPdfToImageConverter >> convert: anInputFile to: anOutputFile [
	"Convenience method"

	self inputFile: anInputFile.
	self outputFile: anOutputFile.
	self convert.
]

{ #category : #'accessing-magritte' }
RlPdfToImageConverter >> descriptionCommand [
	<magritteDescription>
	<gtInspectorPresentationOrder: 1>
	^ MAStringDescription new
		accessor: #command;
		readonly: true;
		yourself
]

{ #category : #'accessing-magritte' }
RlPdfToImageConverter >> descriptionSomet [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #somet;
		yourself
]

{ #category : #accessing }
RlPdfToImageConverter >> outputFile [
	^ outputFile ifNil: [ outputFile := Tempfile new ]
]

{ #category : #accessing }
RlPdfToImageConverter >> somet [
	^ self maLazyFromDescriptionOf: #somet
]

{ #category : #accessing }
RlPdfToImageConverter >> somet: anObject [
	somet := anObject
]
