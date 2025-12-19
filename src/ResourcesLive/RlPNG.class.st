Class {
	#name : 'RlPNG',
	#superclass : 'RlPicture',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlPNG class >> fileExtensions [
	^ #('png')
]

{ #category : 'accessing' }
RlPNG class >> mimeTypes [
	^ { ZnMimeType imagePng }
]
