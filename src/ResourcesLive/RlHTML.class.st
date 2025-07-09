Class {
	#name : #RlHTML,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlHTML class >> fileExtensions [
	^ #('html' 'shtml' 'dhtml' 'htm')
	
	"SHTML is a file extension that lets the web server know the file should be processed as using Server Side Includes (SSI).

(HTML is...you know what it is, and DHTML is Microsoft's name for Javascript+HTML+CSS or something). 

	per https://stackoverflow.com/a/519629"
]

{ #category : #'file types' }
RlHTML class >> mimeTypes [

	^ { ZnMimeType textHtml}
]

{ #category : #'as yet unclassified' }
RlHTML >> asMarkdown [

	^ PBApplication uniqueInstance newCommandStringFactory
		bindingAt: #htmlString put: self contents;
		script: 'import html2text';
	    resultExpression: 'html2text.html2text(htmlString)';
	    sendAndWait.
]

{ #category : #accessing }
RlHTML >> clip [
	| tempFile command |
	OSPlatform current isMacOSX ifFalse: [ self error: 'Only implemented on Mac OSX' ].
	[ 
		tempFile := FileReference newTempFilePrefix: 'htmllink' suffix: 'txt'.
		tempFile writeStreamDo: [ :s | s nextPutAll: self file contents ].
		command := '/usr/bin/textutil -format html -convert rtf -stdout ' , (tempFile fullName surroundedBy: '"') , ' | /usr/bin/pbcopy'.
		LibC system: command
	] ensure: [ tempFile delete ]

	"Implementation note: the first attempt was to pass the input via a HEREDOC, but that didn't seem to work with LibC"
]

{ #category : #'GT Views' }
RlHTML >> contentsGtViewFor: aView [

	^ self class
		markdown: self asMarkdown 
		gtViewOn: aView 
		do: []
]

{ #category : #utilities }
RlHTML >> edit [
	LibC system: 'open -a MacVim "', self file fullName, '"'.
]

{ #category : #utilities }
RlHTML >> soup [
	^ Soup fromString: self file contents
]
