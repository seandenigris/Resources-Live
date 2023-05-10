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
		argumentAt: #inputFile put: self extentFile;
		extent
]

{ #category : #accessing }
RlPicture >> extentFile [

	^ self file
]

{ #category : #accessing }
RlPicture >> gtFigureFor: aView [
	<gtView>
	^ aView pannable
		title: 'Picture';
		priority: 1;
		stencil: [ 
			| image |
			image := GtFileUtility imageElementFromFileReference: self gtFileUtilityFile.
			image
				size: self extent;
				yourself ]
]

{ #category : #accessing }
RlPicture >> gtFileUtilityFile [

	^ self file
]
