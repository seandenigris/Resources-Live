Class {
	#name : #RlRTF,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlRTF class >> fileExtensions [
	^ #('rtf')
]

{ #category : #accessing }
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

{ #category : #accessing }
RlRTF >> gtContentsFor: aView [
	
	| out |
	^ aView textEditor
		title: 'Contents';
		text: [ 
			out := Tempfile withSuffix: '.md'.
			SuPandoc rtfToMarkdown
				argumentAt: #inputFile put: self file;
				argumentAt: #outputFile put: out;
				run.
			out contents ]
]
