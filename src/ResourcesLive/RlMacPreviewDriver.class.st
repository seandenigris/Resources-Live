Class {
	#name : 'RlMacPreviewDriver',
	#superclass : 'Object',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
RlMacPreviewDriver >> application [

	^ CwMacPreview reference
]

{ #category : 'as yet unclassified' }
RlMacPreviewDriver >> show: anRlPDF [ 
	
	self application open: anRlPDF
]
