Class {
	#name : 'RlRTF',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlRTF class >> fileExtensions [
	^ #('rtf')
]

{ #category : 'accessing' }
RlRTF class >> fromMarkdown: aString [

	| inputFile outputFile |
	inputFile := Tempfile new
		writeStreamDo: [ :str | str << aString withUnixLineEndings ];
		yourself.
	outputFile := Tempfile withSuffix: '.rtf'.

	SuPandoc markdownToRTF
		argumentAt: #inputFile put: inputFile;
		argumentAt: #outputFile put: outputFile;
		run.

	^ outputFile asRlResource
]

{ #category : 'accessing' }
RlRTF >> asMarkdown [

	| out |
	out := Tempfile withSuffix: '.md'.
	SuPandoc rtfToMarkdown
		argumentAt: #inputFile put: self file;
		argumentAt: #outputFile put: out;
		run.
	^ out asRlResource
]

{ #category : 'accessing' }
RlRTF >> asTxt [

	| targetExtension tempFile |
	targetExtension := 'txt'.
	tempFile := Tempfile withSuffix: '.', targetExtension.

	SuGenericUnixCommand new
		template: 'textutil -convert {format} -output {destination} {source}';
		argumentAt: #format put: targetExtension;
		argumentAt: #source put: self file;
		argumentAt: #destination put: tempFile;
		execute.
		
	^ tempFile asRlResource
]

{ #category : 'accessing' }
RlRTF >> contentsGtViewFor: aView [
	
	^ aView textEditor
		title: 'Contents';
		text: [ self asMarkdown contents ]
]
