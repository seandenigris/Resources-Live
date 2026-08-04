"
I am an abstract resource containing Pharo source code that can be compared with and selectively loaded into the current image.

Concrete subclasses adapt a source format. I create a transient RlCodeLoadPlan for review and selection, but I retain no staging or application state.
"
Class {
	#name : 'RlSmalltalkSource',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlSmalltalkSource class >> fileExtensions [
	^ #('st')

]

{ #category : 'testing' }
RlSmalltalkSource class >> isAbstract [
	^ self = RlSmalltalkSource

]

{ #category : 'testing' }
RlSmalltalkSource class >> isClassFor: aFileReference [
	^ false

]

{ #category : 'changes' }
RlSmalltalkSource >> codeLoadPlan [
	^ RlCodeLoadPlan on: self

]

{ #category : 'changes' }
RlSmalltalkSource >> codeSelectionMaterializationFor: anRlCodeLoadPlan [
	self subclassResponsibility

]

{ #category : 'gt - views' }
RlSmalltalkSource >> gtChangesFor: aView context: aContext [
	<gtView>

	^ self codeLoadPlan
		gtChangesFor: aView
		context: aContext

]

{ #category : 'testing' }
RlSmalltalkSource >> hasChanges [
	^ self codeLoadPlan hasChanges

]

{ #category : 'changes' }
RlSmalltalkSource >> loadableChanges [
	self subclassResponsibility

]
