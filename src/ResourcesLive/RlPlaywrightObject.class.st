Class {
	#name : 'RlPlaywrightObject',
	#superclass : 'Object',
	#instVars : [
		'model'
	],
	#category : 'ResourcesLive-Web Driving-Playwright',
	#package : 'ResourcesLive',
	#tag : 'Web Driving-Playwright'
}

{ #category : 'accessing' }
RlPlaywrightObject >> returnA: aClass fromScript: aBlock [

	| factory |
	factory := self model newCommandFactory.
	aBlock value: factory.
	^ aClass on: factory sendAndWait
]
