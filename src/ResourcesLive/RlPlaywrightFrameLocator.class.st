"
See {{gtClass:LlPlaywrightLocator}} class comment.

From [the doc](https://playwright.dev/python/docs/api/class-framelocator): *FrameLocator represents a view to the iframe on the page. It captures the logic sufficient to retrieve the iframe and locate elements in that iframe. FrameLocator can be created with either page.frame_locator(selector) or locator.frame_locator(selector) method.*
"
Class {
	#name : 'RlPlaywrightFrameLocator',
	#superclass : 'RlPlaywrightObject',
	#category : 'ResourcesLive-Web Driving-Playwright',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-Playwright'
}

{ #category : 'instance creation' }
RlPlaywrightFrameLocator class >> on: proxy [
	^ self new
		model: proxy;
		yourself
]

{ #category : 'player API' }
RlPlaywrightFrameLocator >> domElementFromSelector: aString [
	
	^ self locator: aString
]

{ #category : 'accessing' }
RlPlaywrightFrameLocator >> locator: aString [
	
	^ self 
		returnA: LlPlaywrightLocator
		fromScript: [ :factory |
				factory << (P3GCall target: self model => #locator positionalArguments: { aString }) ]
]

{ #category : 'accessing' }
RlPlaywrightFrameLocator >> model [

	^ model
]

{ #category : 'accessing' }
RlPlaywrightFrameLocator >> model: aPBProxyObject [
	model := aPBProxyObject
]
