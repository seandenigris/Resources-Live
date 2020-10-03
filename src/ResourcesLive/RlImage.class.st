Class {
	#name : #RlImage,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #testing }
RlImage class >> isClassFor: file [
	"I'm abstract"
	^ self ~= RlImage
]

{ #category : #accessing }
RlImage >> extent [
	^ RlVisualDimensioner new
			input: self;
			extent
]
