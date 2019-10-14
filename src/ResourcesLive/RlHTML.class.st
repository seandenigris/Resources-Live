Class {
	#name : #RlHTML,
	#superclass : #RlResource,
	#category : 'ResourcesLive-Core'
}

{ #category : #'file types' }
RlHTML class >> fileExtensions [
	^ #('html')
]

{ #category : #utilities }
RlHTML >> edit [
	LibC system: 'open -a MacVim "', self file fullName, '"'.
]

{ #category : #utilities }
RlHTML >> soup [
	^ Soup fromString: self file contents
]
