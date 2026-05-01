Class {
	#name : 'RlAppleScriptWebPage',
	#superclass : 'Object',
	#instVars : [
		'url',
		'browser'
	],
	#category : 'ResourcesLive-Web Driving-AppleScript',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-AppleScript'
}

{ #category : 'accessing' }
RlAppleScriptWebPage class >> atUrl: aUrl in: browser [
	^ self new
		basicUrl: aUrl;
		browser: browser;
		yourself
]

{ #category : 'as yet unclassified' }
RlAppleScriptWebPage >> basicUrl: aUrl [ 
	url := aUrl
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> browser [

	^ browser
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> browser: anObject [

	browser := anObject
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> cookie [
	"https://stackoverflow.com/a/57909990"
	^ self doJavascript: 'document.cookie'
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> doJavascript: script [
	^ self doJavascriptViaPython: script
	
	"The OsaScript bridge (see `doJavascriptViaOSA:`) is finicky, so trying to use Python instead by default"
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> doJavascriptViaOSA: script [
	^ self browser doJavascript: script in: self documentIdString
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> doJavascriptViaPython: script [
	
	^ self pythonInstance do_JavaScript: script string
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> documentIdString [
	^ 'first document where URL begins with ', self url asString surroundedByDoubleQuotes
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> domElementFromSelector: aString [ 
	^ LlDomElementLocator querySelector: aString in: self
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> elementLocatorFromId: aString [

	^ self domElementFromSelector: '#', aString
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> exists [
	^ self browser applescriptTellTo: 'exists (', self documentIdString, ')'
]

{ #category : 'as yet unclassified' }
RlAppleScriptWebPage >> iframeSrcBeginningWith: aString [
	
	| urlString js jsTemplate |
	
	jsTemplate := 'frameSelector = `iframe[src^={url}]`;
document.querySelector(frameSelector).getAttribute(''src'')'.
	js := jsTemplate format: { #url -> aString surroundedBySingleQuotes } asDictionary.
	urlString := self doJavascriptViaPython: js.

	^ LlVideoUrl fromString: urlString.
	
	"Implementation notes: 
	- couldn't get this to work with the OsaScript bridge, so using Python instead. 
	- Query selector syntax adapted from https://stackoverflow.com/a/303961"
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> isDocumentComplete [

	^ self browser 
		doJavascript: 'document.readyState == "complete"'
		in: self documentIdString.
		
	"Reference: https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState via https://codereview.stackexchange.com/a/91967"
]

{ #category : 'as yet unclassified' }
RlAppleScriptWebPage >> loadEnsured [

	self exists ifTrue: [ ^ self ].
	
	self browser open: self url.
	self waitForDocumentToLoad
]

{ #category : 'as yet unclassified' }
RlAppleScriptWebPage >> name [

	^ self pythonInstance name callMethod: #get
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> onQuit [
	| template script |
	template := 'repeat with t in tabs of windows
		tell t
			if URL is "{url}" then
				close
				exit repeat
			end if
		end tell
	end repeat'.
	script := template format: { #url -> self url asString } asDictionary.
	self browser tellApplicationTo: script
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> printOn: aStream [

	aStream
		nextPutAll: self documentIdString;
		nextPutAll: ' ('.
	super printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'as yet unclassified' }
RlAppleScriptWebPage >> pythonInstance [

	^ PBApplication start newCommandStringFactory
		script: 'from appscript import *';
		bindingAt: #url put: self url asString;
	    resultExpression: 'app("Safari").documents[its.URL.beginswith(url)][1]';
	    sendAndWait.
	    
	"Appscript reference filtering doc: https://appscript.sourceforge.io/py-appscript/doc_3x/appscript-manual/09_referenceforms.html"
]

{ #category : 'as yet unclassified' }
RlAppleScriptWebPage >> source [
	| sourceString htmlFile result |
	sourceString := self pythonInstance source callMethod: #get.
	htmlFile := Tempfile named: self name asFilename , '.html'.
	htmlFile writeStreamDo: [ :str | str << sourceString ].
	result := RlHTML on: htmlFile.
	^ result
		source: self url;
		yourself.
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> url [
	^ url
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> url: aUrl [
	| scriptTemplate script |
	scriptTemplate := 'set URL of {document} to "{targetUrl}"'.
	script := scriptTemplate format: {
		#document -> self documentIdString.
		#targetUrl -> aUrl asString } asDictionary.
	self browser applescriptTellTo: script.
	self basicUrl: aUrl.
	self waitForDocumentToLoad.
]

{ #category : 'accessing' }
RlAppleScriptWebPage >> waitForDocumentToLoad [
			
	[ [ self exists and: [  self isDocumentComplete ] ] whileFalse: [ 0.2 seconds wait ] ]
		valueWithin: 10 seconds
		onTimeout: [].
]
