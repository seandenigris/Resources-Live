Class {
	#name : 'RlDomElementLocator',
	#superclass : 'Object',
	#instVars : [
		'querySelector',
		'page'
	],
	#category : 'ResourcesLive-Web Driving-AppleScript',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-AppleScript'
}

{ #category : 'accessing' }
RlDomElementLocator class >> querySelector: aString in: page [
	^ self new
		querySelector: aString;
		page: page;
		yourself
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> doJavaScript: aString [
	^ self selfEvaluate: aString.
]

{ #category : 'accessing' }
RlDomElementLocator >> exists [
	| js |
	js := (SuJSScript queryingSelector + ' !== null')
		argumentAt: #selectors put: self querySelector surroundedByDoubleQuotes;
		yourself.

	^ self page doJavascript: js
]

{ #category : 'testing' }
RlDomElementLocator >> getAttribute: aString [
	^ self selfEvaluate: 'getAttribute(', aString surroundedBySingleQuotes, ')'
]

{ #category : 'testing' }
RlDomElementLocator >> hasAttribute: aString [
	^ self selfEvaluate: 'hasAttribute(', aString surroundedBySingleQuotes, ')'
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> highlight [

	self selfEvaluate: 'style.outline = "2px solid red";'.
	self selfEvaluate: 'style.boxShadow = "0 0 20px red";'
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> innerHTML [

	^ RlHTML fromString: (self selfEvaluate: 'innerHTML')
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> outerHTML [

	^ RlHTML fromString: (self selfEvaluate: 'outerHTML')
]

{ #category : 'accessing' }
RlDomElementLocator >> page [

	^ page
]

{ #category : 'accessing' }
RlDomElementLocator >> page: anObject [

	page := anObject
]

{ #category : 'accessing' }
RlDomElementLocator >> querySelector [
	^ querySelector
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> querySelector: aString [ 
	querySelector := aString
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> scrollIntoView [

	self selfEvaluate: 'scrollIntoView(\{
    behavior: "smooth",
    block: "center",
    inline: "center"
  \});'
]

{ #category : 'accessing' }
RlDomElementLocator >> selfEvaluate: aString [ 

	| js escapedQuerySelector |
	escapedQuerySelector := self querySelector copyReplaceAll: '"' with: '\"'.
	js := (SuJSScript queryingSelector -> aString)
		argumentAt: #selectors put: escapedQuerySelector surroundedByDoubleQuotes;
		yourself.

	^ self page doJavascript: js
]

{ #category : 'accessing' }
RlDomElementLocator >> soup [

	^ (Soup fromString: self outerHTML contents) children first
	
	"Adapted from https://stackoverflow.com/a/22078164"
]

{ #category : 'as yet unclassified' }
RlDomElementLocator >> textContent [

	^ self selfEvaluate: 'textContent'
]
