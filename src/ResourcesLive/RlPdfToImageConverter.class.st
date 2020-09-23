Class {
	#name : #RlPdfToImageConverter,
	#superclass : #Object,
	#instVars : [
		'inputFile',
		'outputFile'
	],
	#classInstVars : [
		'current'
	],
	#category : #'ResourcesLive-Utilities'
}

{ #category : #converting }
RlPdfToImageConverter class >> convert: inputFile to: outputFile [
	self new
		input: inputFile;
		outputFile: outputFile;
		convert
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

{ #category : #private }
RlPdfToImageConverter >> commandTemplate [
	self subclassResponsibility
]

{ #category : #converting }
RlPdfToImageConverter >> convert [
	self shell ensureSucceeds: self command.
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

{ #category : #converting }
RlPdfToImageConverter >> ensureSucceeds: aString [
	| exitStatus |
	exitStatus := LibC system: aString.
	self assert: exitStatus equals: 0
]

{ #category : #views }
RlPdfToImageConverter >> gtCLIViewFor: aView [
	<gtView>
	^ aView text 
		title: 'CLI';
		text: self command
]

{ #category : #accessing }
RlPdfToImageConverter >> input: anObject [
	inputFile := anObject
]

{ #category : #accessing }
RlPdfToImageConverter >> inputFile [
	^ inputFile
]

{ #category : #accessing }
RlPdfToImageConverter >> outputFile [
	^ outputFile ifNil: [ outputFile := Tempfile new ]
]

{ #category : #accessing }
RlPdfToImageConverter >> outputFile: anObject [
	outputFile := anObject
]

{ #category : #converting }
RlPdfToImageConverter >> shell [
	"Hook for later delegation to a library"
	^ self
]
