Class {
	#name : #RlResourceSpecification,
	#superclass : #TestCase,
	#category : #'ResourcesLive-Tests'
}

{ #category : #accessing }
RlResourceSpecification >> testCreateFromFileReference [

	| file resource |
	file := FileLocator temp / 'mytestfile'.
	resource := file asRlResource.
	resource class should be: RlResource.
]
