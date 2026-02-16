Class {
	#name : 'RlEpubFileXmlMimeTypeResolver',
	#superclass : 'GtFileMimeTypeResolver',
	#category : 'ResourcesLive-GToolkit',
	#package : 'ResourcesLive-GToolkit'
}

{ #category : 'public' }
RlEpubFileXmlMimeTypeResolver class >> mimeType [
	"Return a given ZnMimeType object that represents the given file extension"
	<return: #ZnMimeType>
	^ ZnMimeType applicationXml
]

{ #category : 'accessing' }
RlEpubFileXmlMimeTypeResolver class >> supportedExtensions [
	"Return collection of extensions that fits the specific mime type"
	<return: #Array of: #String>
	^ #( 'opf' )
]
