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
RlVideo class >> exampleExtent [
	<gtExample>
	| extent |
	extent := self example extent.
	self assert: extent x equals: 716.
	self assert: extent y equals: 720.
	^ extent
]

{ #category : #accessing }
RlVideo class >> fileExtensions [
	^ #('mov' 'mp4')
]

{ #category : #accessing }
RlVideo >> animatedGifCreator [
	^ Su_ffmpeg convertingVideoToAnimatedGIF
		argumentAt: #inputFile put: self asFileReference;
		argumentAt: #gifWidth put: self extent x;
		yourself.

]

{ #category : #accessing }
RlVideo >> extent [
	^ Su_ffmpeg new
		argumentAt: #inputFile put: self file;
		extent
]
