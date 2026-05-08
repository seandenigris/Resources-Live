Class {
	#name : 'RlVideo',
	#superclass : 'RlResource',
	#traits : 'RlTPlayable',
	#classTraits : 'RlTPlayable classTrait',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'examples' }
RlVideo class >> example [
	<gtExample>
	^ (self exampleSupportFolder / 'gt.mov') asRlResource.
]

{ #category : 'examples' }
RlVideo class >> exampleExtent [
	<gtExample>
	| extent |
	extent := self example extent.
	self assert: extent x equals: 716.
	self assert: extent y equals: 720.
	^ extent
]

{ #category : 'accessing' }
RlVideo class >> fileExtensions [
	^ #('mov' 'mp4' 'm4v')
]

{ #category : 'accessing' }
RlVideo >> animatedGifCreator [
	^ SuFfmpeg convertingVideoToAnimatedGIF
		argumentAt: #inputFile put: self asFileReference;
		argumentAt: #gifWidth put: self extent x;
		yourself.

]

{ #category : 'playing' }
RlVideo >> defaultDriver [

	^ RlApplescriptMediaDriver "RlPythonMpv" new
]

{ #category : 'as yet unclassified' }
RlVideo >> duration [

	^ self ffprobeOutput duration
]

{ #category : 'accessing' }
RlVideo >> extent [

	^ self ffprobeOutput resolution
	
	"
	`#extent` is Smalltalk lingo for dimensions
	
	Formerly implemented as:
		^ SuFfmpeg new
			argumentAt: #inputFile put: self file;
			extent
	"
]

{ #category : 'as yet unclassified' }
RlVideo >> ffprobeOutput [

	^ SuFfprobe into: self file
]

{ #category : 'as yet unclassified' }
RlVideo >> handBrakeEncodedWith: aBlock [
	
	| result |
	result := Tempfile named: self file basename.
	SuHandBrakeCli
		encode: self file
		to: result
		with: aBlock.
		
	^ result
]

{ #category : 'playing' }
RlVideo >> playableClass [
	^ RlDomVideo
]

{ #category : 'as yet unclassified' }
RlVideo >> resolution [

	^ self extent
]

{ #category : 'accessing' }
RlVideo >> url [
	^ self file asUrl
]
