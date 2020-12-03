Class {
	#name : #RlAppendExamples,
	#superclass : #Object,
	#category : #'ResourcesLive-GToolkit-Examples'
}

{ #category : #support }
RlAppendExamples class >> append: argument to: directory assertEquals: expected [
	<gtExample>
	self
		given: [ directory ]
		when: [ :parent | parent rlAppend: argument  ]
		then: [ :result :parent | self assert: result equals: expected ].
]

{ #category : #accessing }
RlAppendExamples class >> childPathSegment [
	^ 'cSub'
]

{ #category : #accessing }
RlAppendExamples class >> compoundPath [
	^ Path workingDirectory / self childPathSegment
]

{ #category : #examples }
RlAppendExamples class >> exampleCompoundPathToLocator [
	<gtExample>
	self append: self compoundPath to: self parentWithoutPath assertEquals: self parentWithoutPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples class >> exampleCompoundPathToLocatorWithPath [
	<gtExample>
	self append: self compoundPath to: self parentWithPath assertEquals: self parentWithPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples class >> exampleCompoundPathToReference [
	<gtExample>
	self append: self compoundPath to: self parentReference assertEquals: self parentReference / self childPathSegment
]

{ #category : #examples }
RlAppendExamples class >> exampleFSMagicStringToLocator [
	<gtExample>
	self append: '.' to: self parentWithoutPath assertEquals: self parentWithoutPath
]

{ #category : #examples }
RlAppendExamples class >> exampleFSMagicStringToLocatorWithPath [
	<gtExample>
	self append: '.' to: self parentWithPath assertEquals: self parentWithPath
]

{ #category : #examples }
RlAppendExamples class >> examplePathToLocator [
	<gtExample>
	self append: Path workingDirectory to: self parentWithoutPath assertEquals: self parentWithoutPath
]

{ #category : #examples }
RlAppendExamples class >> examplePathToLocatorWithPath [
	<gtExample>
	self append: Path workingDirectory to: self parentWithPath assertEquals: self parentWithPath
]

{ #category : #examples }
RlAppendExamples class >> exampleStringToLocator [
	<gtExample>
	self append: self childPathSegment to: self parentWithoutPath assertEquals: self parentWithoutPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples class >> exampleStringToLocatorWithPath [
	<gtExample>
	self append: self childPathSegment to: self parentWithPath assertEquals: self parentWithPath / self childPathSegment
]

{ #category : #accessing }
RlAppendExamples class >> parentPathSegment [
	^ 'pSub'
]

{ #category : #accessing }
RlAppendExamples class >> parentReference [
	^ self parentWithoutPath resolve
]

{ #category : #accessing }
RlAppendExamples class >> parentWithPath [
	^ self parentWithoutPath / self parentPathSegment.
]

{ #category : #accessing }
RlAppendExamples class >> parentWithPath: aString [
	^ self parentWithoutPath / aString.
]

{ #category : #accessing }
RlAppendExamples class >> parentWithoutPath [
	^ FileLocator home.
]
