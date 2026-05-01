Class {
	#name : 'RlPlaywrightBrowser',
	#superclass : 'RlPlaywrightObject',
	#category : 'ResourcesLive-Web Driving-Playwright',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-Playwright'
}

{ #category : 'instance creation' }
RlPlaywrightBrowser class >> on: proxy [
	^ self new
		model: proxy;
		yourself
]

{ #category : 'accessing' }
RlPlaywrightBrowser >> close [
	^ self model newCommandFactory
		<< (P3GCall target: self model => #close positionalArguments: { });
		sendAndWait.
]

{ #category : 'accessing' }
RlPlaywrightBrowser >> model [

	^ model
]

{ #category : 'accessing' }
RlPlaywrightBrowser >> model: aPBProxyObject [
	model := aPBProxyObject
]

{ #category : 'accessing' }
RlPlaywrightBrowser >> openOn: aUrl [
]
