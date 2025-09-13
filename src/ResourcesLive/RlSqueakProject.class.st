Class {
	#name : #RlSqueakProject,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'as yet unclassified' }
RlSqueakProject class >> fileExtensions [

	^ #('pr')
]

{ #category : #'as yet unclassified' }
RlSqueakProject >> summary [

	^ self
		propertyAt: #summary
		ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
RlSqueakProject >> summary: aString [

	self
		propertyAt: #summary
		putRemovingNil: aString
]

{ #category : #'as yet unclassified' }
RlSqueakProject >> title [

	^ self
		propertyAt: #title
		ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
RlSqueakProject >> title: aString [

	self
		propertyAt: #title
		putRemovingNil: aString
]
