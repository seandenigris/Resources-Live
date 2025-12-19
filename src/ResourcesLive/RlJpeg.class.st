Class {
	#name : 'RlJPEG',
	#superclass : 'RlPicture',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'examples' }
RlJPEG class >> example [
	<gtExample>
	^ RlPDF exampleReceipt imageResource
]

{ #category : 'file types' }
RlJPEG class >> fileExtensions [
	^ #('jpg')
]

{ #category : 'file types' }
RlJPEG class >> mimeTypes [
	^ { ZnMimeType imageJpeg }
]
