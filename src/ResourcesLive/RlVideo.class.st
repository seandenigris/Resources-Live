Class {
	#name : #RlVideo,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlVideo class >> example [
	<gtExample>
	^ (self exampleSupportFolder / 'gt.mov') asRlResource.
]

{ #category : #accessing }
RlVideo class >> fileExtensions [
	^ #('mov' 'mp4')
]

{ #category : #accessing }
RlVideo >> animatedGifCreator [
	^ RlConvertVideoToAnimatedGIF new
		input: self;
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
