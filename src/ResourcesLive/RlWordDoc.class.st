Class {
	#name : #RlWordDoc,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlWordDoc class >> fileExtensions [
	^ #('doc')
]

{ #category : #accessing }
RlWordDoc >> asTxt [

	| targetExtension tempFile |
	targetExtension := 'txt'.
	tempFile := Tempfile withSuffix: '.', targetExtension.

	SuGenericUnixCommand new
		template: 'textutil -convert {format} -output {destination} {source}';
		argumentAt: #format put: targetExtension;
		argumentAt: #source put: self file;
		argumentAt: #destination put: tempFile;
		execute.
		
	^ tempFile
]

{ #category : #accessing }
RlWordDoc >> gtContentsFor: aView [

	self file ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Contents';
		priority: 50;
		object: [ self asTxt ];
		view: #gtContentsFor:;
		yourself
]
