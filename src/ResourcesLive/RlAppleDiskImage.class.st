Class {
	#name : 'RlAppleDiskImage',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'accessing' }
RlAppleDiskImage class >> fileExtensions [
	^ #('dmg')
]

{ #category : 'accessing' }
RlAppleDiskImage >> verifySha256Checksum: aString [

	self file sha256 = aString
		ifFalse: [ self error: 'SHA256 does not match' ]
]
