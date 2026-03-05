Class {
	#name : 'RlEmailSender',
	#superclass : 'Object',
	#instVars : [
		'email',
		'contact'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'as yet unclassified' }
RlEmailSender class >> of: anRlEmail [

	^ self new
		email: anRlEmail;
		yourself
]

{ #category : 'as yet unclassified' }
RlEmailSender >> address [

	self email ifNil: [ ^ nil ].
	
	^ self email senderEmail.
]

{ #category : 'as yet unclassified' }
RlEmailSender >> addressBook [

	^ self email ifNotNil: #addressBook
]

{ #category : 'as yet unclassified' }
RlEmailSender >> contact [

	contact ifNotNil: [ ^ contact ].
	
	self addressBook ifNil: [ ^ nil ].

	^ contact := self addressBook contacts 
		detect: [ :c | self email isSender: c ]
		ifNone: [ nil ]
]

{ #category : 'as yet unclassified' }
RlEmailSender >> displayStringOn: aStream [

	self contact ifNotNil: [ :c |
		aStream display: c.
		^ self ].
	
	self address ifNotNil: [ :a |
		aStream display: a ]
]

{ #category : 'accessing' }
RlEmailSender >> email [
	^ email
]

{ #category : 'accessing' }
RlEmailSender >> email: anObject [
	email := anObject
]

{ #category : 'as yet unclassified' }
RlEmailSender >> printOn: aStream [

	self printFromDisplayStringOn: aStream
]
