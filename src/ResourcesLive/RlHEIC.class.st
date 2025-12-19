Class {
	#name : 'RlHEIC',
	#superclass : 'RlPicture',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlHEIC class >> fileExtensions [
	^ #('heic')
]

{ #category : 'accessing' }
RlHEIC >> extentFile [

	^ self gtFileUtilityFile
]

{ #category : 'accessing' }
RlHEIC >> gtFileUtilityFile [

	| target |
	target := Tempfile withSuffix: '.jpg'.
	SuImageMagick teConvert: self file to: target.
	^ target
]
