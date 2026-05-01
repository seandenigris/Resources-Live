"
Think {{gtClass:FileLocator}}, but for the DOM.

From [the doc](https://playwright.dev/python/docs/api/class-framelocator): *FrameLocator represents a view to the iframe on the page. It captures the logic sufficient to retrieve the iframe and locate elements in that iframe. FrameLocator can be created with either page.frame_locator(selector) or locator.frame_locator(selector) method.*
"
Class {
	#name : 'RlPlaywrightLocator',
	#superclass : 'RlPlaywrightObject',
	#category : 'ResourcesLive-Web Driving-Playwright',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-Playwright'
}

{ #category : 'instance creation' }
RlPlaywrightLocator class >> on: proxy [
	^ self new
		model: proxy;
		yourself
]

{ #category : 'accessing' }
RlPlaywrightLocator >> doesNotUnderstand: aMessage [

	"Currently we only support getters"
	aMessage numArgs > 0 ifTrue: [ ^ super doesNotUnderstand: aMessage ].
	
	^ self model newCommandFactory
		<< (P3GCall target: self model => #evaluate positionalArguments: { 'node => node.', aMessage selector });
		sendAndWait.
]

{ #category : 'API' }
RlPlaywrightLocator >> evaluate: aString [
	"Reference: https://playwright.dev/python/docs/api/class-locator#locator-evaluate"
	^ self model newCommandFactory
		<< (P3GCall target: self model => #evaluate positionalArguments: { aString });
		sendAndWait.
]

{ #category : 'accessing' }
RlPlaywrightLocator >> model [

	^ model
]

{ #category : 'accessing' }
RlPlaywrightLocator >> model: aPBProxyObject [
	model := aPBProxyObject
]

{ #category : 'actions' }
RlPlaywrightLocator >> selfEvaluate: aString [
	"aString - what you would type in JS after `element.`"
	^ self evaluate: 'node => node.', aString
]
