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
RlShapeFile class >> initialize [

	self pyshpInstall
]

{ #category : #'as yet unclassified' }
RlShapeFile class >> pyshpInstall [

	PBApplication uniqueInstance installModule: 'pyshp'
]

{ #category : #'as yet unclassified' }
RlShapeFile >> asJson [

	^ PBApplication uniqueInstance newCommandStringFactory
		bindingAt: #sf put: self pythonInstance;
		"script: '';"
		resultExpression: 'sf.__geo_interface__';
	    sendAndWait.
]

{ #category : #'as yet unclassified' }
RlShapeFile >> featuresAs: aClass [

	^ self asJson 
		at: #features
		ifPresent: [ :aCol | aCol collect: [ :aDict | aClass fromDictionary: aDict ] ]
		ifAbsent: [ #() ]
]

{ #category : #accessing }
RlShapeFile >> pythonInstance [

	pythonInstance ifNotNil: [ ^ pythonInstance ].
	
	^ pythonInstance := PBApplication uniqueInstance newCommandStringFactory
		bindingAt: #shapeFilePath put: self file fullName;
		script: 'import shapefile';
		resultExpression: 'shapefile.Reader(shapeFilePath)';
	    sendAndWait.
]
