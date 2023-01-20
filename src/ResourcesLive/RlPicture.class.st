Class {
	#name : #RlPicture,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlPicture class >> fileExtensions [
	^ #()
]

{ #category : #testing }
RlPicture class >> isClassFor: file [
	"I'm abstract"
	^ self ~= RlPicture and: [ super isClassFor: file ]
]

{ #category : #accessing }
RlPicture >> asForm [
	^ self file binaryReadStreamDo: [ :str |
		Form fromBinaryStream: str ]
]

{ #category : #accessing }
RlPicture >> extent [
	^ SuFfmpeg new
		argumentAt: #inputFile put: self file;
		extent
]

{ #category : #accessing }
RlPicture >> gtFigureFor: aView [
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
