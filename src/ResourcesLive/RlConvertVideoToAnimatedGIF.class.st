Class {
	#name : 'RlConvertVideoToAnimatedGIF',
	#superclass : 'SuGenericUnixCommand',
	#instVars : [
		'outputFile',
		'gifWidth',
		'input'
	],
	#category : 'ResourcesLive-Utilities',
	#package : 'ResourcesLive',
	#tag : 'Utilities'
}

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> argumentSource [
	^ {
		#inputFile -> self input asFileReference fullName.
		#gifWidth -> self gifWidth.
		#outputFile -> self outputFile fullName } asDictionary
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> gifWidth [
	^ gifWidth ifNil: [ 320 ]
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> gifWidth: anObject [
	gifWidth := anObject
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> initialize [
	super initialize.
	
	"Adapted from *https://superuser.com/a/556031*"
	template := 'ffmpeg -i "{inputFile}" -vf "fps=10,scale={gifWidth}:-1:flags=lanczos" -c:v pam -f image2pipe - | convert -delay 10 - -loop 0 -layers optimize "{outputFile}"'.
	^ self
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> input [
	^ input
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> input: convertibleToFile [
	input := convertibleToFile
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> inputFile [
	^ input
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> outputFile [
	^ outputFile ifNil: [ outputFile := Tempfile withSuffix: '.gif' ]
]

{ #category : 'accessing' }
RlConvertVideoToAnimatedGIF >> outputFile: file [
	outputFile := file
]
