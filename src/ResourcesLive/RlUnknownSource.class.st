Class {
	#name : #RlUnknownSource,
	#superclass : #Object,
	#category : 'ResourcesLive-Core'
}

{ #category : #'as yet unclassified' }
RlUnknownSource >> equals: rhs [
	^ self class = rhs class
]

{ #category : #'as yet unclassified' }
RlUnknownSource >> isNil [
	^ true
]
