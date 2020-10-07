Class {
	#name : #RlBlOcrSelectionHandler,
	#superclass : #BlVisualSelectionHandler,
	#category : #'ResourcesLive-GToolkit'
}

{ #category : #accessing }
RlBlOcrSelectionHandler >> mouseDownEvent: anEvent [
	anEvent button = BlMouseButton secondary ifTrue: [ Halt once. ^ self inspect ].
	super mouseDownEvent: anEvent.
]
