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

{ #category : 'accessing' }
RlVideo >> extent [
	^ SuFfmpeg new
		argumentAt: #inputFile put: self file;
		extent
]
