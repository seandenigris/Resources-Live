"
I am an abstract resource containing Pharo source code that can be compared with and selectively loaded into the current image.

My subclasses understand particular serialization formats. I intentionally do not retain a load plan because selection is a transient operation state owned by RlCodeLoadPlan.
"
Class {
	#name : 'RlSmalltalkSource',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Code',
	#package : 'ResourcesLive',
	#tag : 'Code'
}

{ #category : 'file types' }
RlSmalltalkSource class >> fileExtensions [
	^ #('st')
]

{ #category : 'testing' }
RlSmalltalkSource class >> isClassFor: aFileReference [
	"I am an abstract dispatch node. Concrete source formats decide whether they recognize a file."

	^ false
]

{ #category : 'changes' }
RlSmalltalkSource >> codeLoadPlan [
	"Answer a fresh operation object describing the changes that loading me would make. Selection and application state intentionally live in the plan rather than in the resource."

	^ RlCodeLoadPlan on: self
]

{ #category : 'testing' }
RlSmalltalkSource >> hasChanges [
	"Answer whether loading me would currently change the image."

	^ self codeLoadPlan hasChanges
]

{ #category : 'changes' }
RlSmalltalkSource >> loadableChanges [
	"Answer format-independent change adapters in source order."

	self subclassResponsibility
]
