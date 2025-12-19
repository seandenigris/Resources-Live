Class {
	#name : 'RlXML',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlXML class >> fileExtensions [
	^ #('xml')
]

{ #category : 'accessing' }
RlXML >> document [

	^ self file readStreamDo: [ :str | XMLDOMParser parse: str ]
]
