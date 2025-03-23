Class {
	#name : #RlShapeFile,
	#superclass : #RlResource,
	#traits : 'PeTPythonWrapper',
	#classTraits : 'PeTPythonWrapper classTrait',
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlShapeFile class >> fileExtensions [
	^ #('shp')
]

{ #category : #'as yet unclassified' }
RlShapeFile >> pyshpInstall [

	PBApplication uniqueInstance installModule: 'pyshp'
]
