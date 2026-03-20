Class {
	#name : 'RlFolderResource',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'testing' }
RlFolderResource class >> isClassFor: file [

	^ file isDirectory
]
