Class {
	#name : 'RlMp3UrlPlaylist',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
RlMp3UrlPlaylist class >> fileExtensions [

	^ #('m3u' 'm3u8')
]

{ #category : 'as yet unclassified' }
RlMp3UrlPlaylist >> spliceCommand [

	| inputFile |
	"Prefer source URL because more likely for splicing to work"
	inputFile := self source 
		ifNotNil: #asString
		ifNil: [ :src | self file ].

	^ SuGenericUnixCommand new
		template: 'ffmpeg -i {inputFile} -c copy -bsf:a aac_adtstoasc {outputFile}';
		argumentAt: #inputFile put: inputFile;
		yourself.
]
