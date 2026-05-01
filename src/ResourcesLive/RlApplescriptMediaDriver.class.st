Class {
	#name : 'RlApplescriptMediaDriver',
	#superclass : 'Object',
	#classVars : [
		'BrowserClass'
	],
	#category : 'ResourcesLive-Web Driving-AppleScript',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-AppleScript'
}

{ #category : 'accessing' }
RlApplescriptMediaDriver class >> browserClass [
	^ BrowserClass
]

{ #category : 'accessing' }
RlApplescriptMediaDriver class >> browserClass: anObject [
	BrowserClass := anObject
]

{ #category : 'accessing' }
RlApplescriptMediaDriver >> browser [

	^ self class browserClass new
]

{ #category : 'accessing' }
RlApplescriptMediaDriver >> initialize [

	| somethingFromJS |
	super initialize.
	
	somethingFromJS := self browser  doJavascript: '1'.
	somethingFromJS = 1 ifFalse: [ self error: 'Can''t doJavaScript in ', self browser class name, ' browser. You probably need to enable "Allow JavaScript from Apple Events" in the "Develop" menu' ].
]

{ #category : 'accessing' }
RlApplescriptMediaDriver >> show: media [

	| result |
	
	self browser
		openInNewWindow: media url;
		activate.
	
	result := LlAppleScriptWebPage atUrl: media url in: self browser.
	result waitForDocumentToLoad.
	^ result
]
