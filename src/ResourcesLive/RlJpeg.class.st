Class {
	#name : #RlJpeg,
	#superclass : #RlImage,
	#category : #'ResourcesLive-Core'
}

{ #category : #examples }
RlJpeg class >> example [
	<gtExample>
	^ RlJpeg on: RlPDF exampleReceipt imageFile
]

{ #category : #'file types' }
RlJpeg class >> fileExtensions [
	^ #('jpg')
]
