"
From [the doc](https://playwright.dev/python/docs/api/class-page): 

*extends: EventEmitter. Page provides methods to interact with a single tab in a Browser, or an extension background page in Chromium. One Browser instance might have multiple Page instances.*
"
Class {
	#name : 'RlPlaywrightPage',
	#superclass : 'RlPlaywrightObject',
	#instVars : [
		'browser'
	],
	#category : 'ResourcesLive-Web Driving-Playwright',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-Playwright'
}

{ #category : 'accessing' }
RlPlaywrightPage class >> on: proxy inBrowser: browser [ 
	^ self new
		model: proxy;
		browser: browser;
		yourself
]

{ #category : 'accessing' }
RlPlaywrightPage >> browser [

	^ browser
]

{ #category : 'accessing' }
RlPlaywrightPage >> browser: anObject [

	browser := anObject
]

{ #category : 'player API' }
RlPlaywrightPage >> domElementFromSelector: aString [
	
	^ self locator: aString
]

{ #category : 'API' }
RlPlaywrightPage >> frameLocator: selectorString [
	"selectorString - any valid CSS selector, plus some custom Playwright additions
	
	Reference: https://playwright.dev/python/docs/api/class-page#page-frame-locator"

	^ self 
		returnA: RlPlaywrightFrameLocator fromScript: [ :factory |
			factory << (P3GCall target: self model => #frame_locator positionalArguments: { selectorString }) ]
]

{ #category : 'player API' }
RlPlaywrightPage >> frameReferenceFromSelector: selectorString [

	^ self frameLocator: selectorString
]

{ #category : 'accessing' }
RlPlaywrightPage >> locator: aString [
	
	^ self 
		returnA: RlPlaywrightLocator
		fromScript: [ :factory |
				factory << (P3GCall target: self model => #locator positionalArguments: { aString }) ]
]

{ #category : 'accessing' }
RlPlaywrightPage >> model [

	^ model
]

{ #category : 'accessing' }
RlPlaywrightPage >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
RlPlaywrightPage >> onQuit [
	self browser close
]

{ #category : 'accessing' }
RlPlaywrightPage >> url: aUrl [
	
	self model newCommandFactory
		<< (P3GCall target: self model => #goto positionalArguments: { aUrl asString });
		sendAndWait
]
