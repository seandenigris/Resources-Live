Class {
	#name : #RlVideo,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #examples }
RlVideo class >> example [
	<gtExample>
	^ (self exampleSupportFolder / 'gt.mov') asRlResource.
]

{ #category : #examples }
RlVideo class >> exampleWidth [
	<gtExample>
	| width |
	width := self example width.
	self assert: width equals: 716.
	^ width
]

{ #category : #accessing }
RlVideo class >> fileExtensions [
	^ #('mov' 'mp4')
]

{ #category : #accessing }
RlVideo >> animatedGifCreator [
	^ RlConvertVideoToAnimatedGIF new
		input: self;
		gifWidth: self width;
		yourself.

]

{ #category : #accessing }
RlVideo >> ensureSucceeds: aString [
	| exitStatus |
	exitStatus := LibC system: aString.
	self assert: exitStatus equals: 0
]

{ #category : #accessing }
RlVideo >> shell [
	^ self
]

{ #category : #accessing }
RlVideo >> width [
	| info matches |
	"Adapted from https://stackoverflow.com/a/7362274"
	info := SuGenericUnixCommand new
		template: 'ffmpeg -i "{inputFile}"';
		argumentSource: { #inputFile -> self file fullName } asDictionary;
		redirectErrorsToOutput;
		output.
	matches := info allRegexMatches: '([1-9]\d*)x(\d+)'.
	self assert: matches size equals: 1.
	^ (matches first copyUpTo: $x) asNumber
]
