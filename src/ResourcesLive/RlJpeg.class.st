Class {
	#name : #RlJPEG,
	#superclass : #RlImage,
	#category : 'ResourcesLive-Core'
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
