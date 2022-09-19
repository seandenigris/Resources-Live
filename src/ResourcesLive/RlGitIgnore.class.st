Class {
	#name : #RlGitIgnore,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlGitIgnore class >> fileExtensions [
	^ #('gitignore')
]

{ #category : #accessing }
RlGitIgnore >> ignoreAllExcept: aCollection [

	| header |
	self file ensureDelete.
	
	header := '# Ignore everything but... (see https://stackoverflow.com/a/987162/424245)

## Ignore everything
*

## But not these files...
'.

	self file writeStreamDo: [ :str |
		str << header.
		aCollection 
			do: [ :exception | str << $! << exception ]
			separatedBy: [ str lf ] ].
]
