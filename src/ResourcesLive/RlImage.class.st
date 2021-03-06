Class {
	#name : #RlImage,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlImage class >> fileExtensions [
	^ #()
]

{ #category : #testing }
RlImage class >> isClassFor: file [
	"I'm abstract"
	^ self ~= RlImage and: [ super isClassFor: file ]
]

{ #category : #accessing }
RlImage >> extent [
	^ SuFfmpeg new
		argumentAt: #inputFile put: self file;
		extent
]

{ #category : #accessing }
RlImage >> gtFigureFor: aView [
	<gtView>
	^ aView pannable
		title: 'Picture';
		priority: 1;
		stencil: [ 
			| image |
			image := GtFileUtility imageElementFromFileReference: self file.
			image
				size: self extent;
				yourself ]
]
