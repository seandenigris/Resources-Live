Class {
	#name : 'RlPicture',
	#superclass : 'RlResource',
	#classVars : [
		'ExifReader'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'accessing' }
RlPicture class >> exifReader [

	^ ExifReader
]

{ #category : 'accessing' }
RlPicture class >> exifReader: anObject [

	ExifReader := anObject
]

{ #category : 'accessing' }
RlPicture class >> fileExtensions [
	^ #()
]

{ #category : 'testing' }
RlPicture class >> isClassFor: file [
	"I'm abstract"
	^ self ~= RlPicture and: [ super isClassFor: file ]
]

{ #category : 'accessing' }
RlPicture >> asElement [
	^ GtFileUtility imageElementFromFileReference: self gtFileUtilityFile
]

{ #category : 'accessing' }
RlPicture >> asForm [
	^ self file binaryReadStreamDo: [ :str |
		Form fromBinaryStream: str ]
]

{ #category : 'as yet unclassified' }
RlPicture >> contents [

	^ self ocr
]

{ #category : 'accessing' }
RlPicture >> contentsGtViewFor: aView [
	<gtView>
	
	^ aView pannable
		title: 'Picture';
		priority: 1;
		stencil: [ 
			self asElement
				size: self extent;
				yourself ]
]

{ #category : 'accessing' }
RlPicture >> exif [

	| exifJson |
	exifJson := self class exifReader exifForFile: self file.
	^ RlExif fromDictionary: exifJson
]

{ #category : 'accessing' }
RlPicture >> exifGtViewFor: aView [
	<gtView>
	^ aView forward
		title: 'EXIF';
		priority: 5;
		object: [ self exif ];
		view: #rawDataGtViewFor:context:
]

{ #category : 'accessing' }
RlPicture >> extent [
	^ SuFfmpeg new
		argumentAt: #inputFile put: self extentFile;
		extent
]

{ #category : 'accessing' }
RlPicture >> extentFile [

	^ self file
]

{ #category : 'accessing' }
RlPicture >> gtFileUtilityFile [

	^ self file
]

{ #category : 'accessing' }
RlPicture >> ocr [
	^ self cache
		at: #ocr
		ifAbsentPut: [ Smalltalk tools ocr ocr: self ]
]
