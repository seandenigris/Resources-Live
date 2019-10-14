Class {
	#name : #RlMp3,
	#superclass : #RlResource,
	#category : 'ResourcesLive-Core'
}

{ #category : #'file types' }
RlMp3 class >> fileExtensions [
	^ #('mp3')
]

{ #category : #'as yet unclassified' }
RlMp3 >> descriptionPlay [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #play;
		yourself
]

{ #category : #'as yet unclassified' }
RlMp3 >> play [
	LibC system: 'afplay ', self file fullName surroundedBySingleQuotes, ' &'.
]
