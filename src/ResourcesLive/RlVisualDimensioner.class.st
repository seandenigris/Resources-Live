"
Technique adapted from https://stackoverflow.com/a/7362274
"
Class {
	#name : #RlVisualDimensioner,
	#superclass : #SuGenericUnixCommand,
	#instVars : [
		'input',
		'extent'
	],
	#category : #'ResourcesLive-Utilities'
}

{ #category : #examples }
RlVisualDimensioner class >> example [
	<gtExample>
	| result |
	result := self new
		input: RlJpeg example;
		run.
	self assert: result extent equals: 934@1700.
	self assert: (result string matchesRegex: 'ffmpeg -i ".*\.jpg" 2>&1').
	^ result
]

{ #category : #accessing }
RlVisualDimensioner >> argumentSource [
	^ { #inputFile -> self input asFileReference fullName } asDictionary
]

{ #category : #accessing }
RlVisualDimensioner >> extent [
	^ extent ifNil: [ self run. extent ]
]

{ #category : #accessing }
RlVisualDimensioner >> height [
	^ self extent y
]

{ #category : #accessing }
RlVisualDimensioner >> initialize [
	super initialize.
	
	template := 'ffmpeg -i "{inputFile}"'.
	^ self
]

{ #category : #accessing }
RlVisualDimensioner >> input [
	^ input
]

{ #category : #accessing }
RlVisualDimensioner >> input: convertibleToFile [
	input := convertibleToFile
]

{ #category : #accessing }
RlVisualDimensioner >> run [
	| info matches |
	info := self
		redirectErrorsToOutput;
		output.
	matches := info allRegexMatches: '([1-9]\d*)x(\d+)'.
	self assert: matches size equals: 1.
	extent := (matches first copyUpTo: $x) asNumber @ (matches first copyAfter: $x) asNumber.
]

{ #category : #accessing }
RlVisualDimensioner >> width [
	^ self extent x
]
