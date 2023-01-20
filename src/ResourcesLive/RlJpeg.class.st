Class {
	#name : #RlJPEG,
	#superclass : #RlPicture,
	#category : #'ResourcesLive-Core'
}

{ #category : #examples }
RlJPEG class >> example [
	<gtExample>
	^ RlJPEG on: RlPDF exampleReceipt imageFile
]

{ #category : #'file types' }
RlJPEG class >> fileExtensions [
	^ #('jpg')
]

{ #category : #'file types' }
RlJPEG class >> mimeTypes [
	^ { ZnMimeType imageJpeg }
]
