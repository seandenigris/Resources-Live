Class {
	#name : #RlAppendExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'ResourcesLive-GToolkit-Examples'
}

{ #category : #support }
RlAppendExamples >> append: argument to: directory assertEquals: expected [
	<gtExample>
	self class
		given: [ directory ]
		when: [ :parent | parent rlAppend: argument  ]
		then: [ :result :parent | 
			self assert: ((parent contains: result) or: [ parent = result ] ).
			self assert: ((parent resolve contains: result resolve) or: [ parent resolve = result resolve ] ).
			self assert: result equals: expected.
			self assert: result resolve equals: expected resolve ].
]

{ #category : #accessing }
RlAppendExamples >> childPathSegment [
	^ 'cSub'
]

{ #category : #accessing }
RlAppendExamples >> compoundPath [
	^ Path workingDirectory / self childPathSegment
]

{ #category : #examples }
RlAppendExamples >> exampleCompoundPathToLocator [
	<gtExample>
	self append: self compoundPath to: self parentWithoutPath assertEquals: self parentWithoutPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples >> exampleCompoundPathToLocatorWithPath [
	<gtExample>
	self append: self compoundPath to: self parentWithPath assertEquals: self parentWithPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples >> exampleCompoundPathToReference [
	<gtExample>
	self append: self compoundPath to: self parentReference assertEquals: self parentReference / self childPathSegment
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicDotToLocator [
	<gtExample>
	self append: '.' to: self parentWithoutPath assertEquals: self parentWithoutPath
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicDotToReference [
	<gtExample>
	self append: '.' to: self parentReference assertEquals: self parentReference
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicSlashToLocator [
	<gtExample>
	self
		should: [ self append: '/' to: self parentWithoutPath assertEquals: 'never reached' ]
		raise: Error
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicSlashToLocatorReference [
	<gtExample>
	self
		should: [ self append: '/' to: self parentReference assertEquals: 'never reached' ]
		raise: Error
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicSlashToLocatorWithPath [
	<gtExample>
	self
		should: [ self append: '/' to: self parentWithPath assertEquals: 'never reached' ]
		raise: Error
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicSpaceToLocator [
	<gtExample>
	self append: ' ' to: self parentWithoutPath assertEquals: self parentWithoutPath / ' '
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicSpaceToLocatorWithPath [
	<gtExample>
	self append: ' ' to: self parentWithPath assertEquals: self parentWithPath / ' '
]

{ #category : #examples }
RlAppendExamples >> exampleFSMagicSpaceToReference [
	<gtExample>
	self append: ' ' to: self parentReference assertEquals: self parentReference / ' '
]

{ #category : #examples }
RlAppendExamples >> examplePathToLocator [
	<gtExample>
	self append: Path workingDirectory to: self parentWithoutPath assertEquals: self parentWithoutPath
]

{ #category : #examples }
RlAppendExamples >> examplePathToLocatorWithPath [
	<gtExample>
	self append: Path workingDirectory to: self parentWithPath assertEquals: self parentWithPath
]

{ #category : #examples }
RlAppendExamples >> examplePathToReference [
	<gtExample>
	self append: Path workingDirectory to: self parentReference assertEquals: self parentReference
]

{ #category : #examples }
RlAppendExamples >> exampleStringToLocator [
	<gtExample>
	self append: self childPathSegment to: self parentWithoutPath assertEquals: self parentWithoutPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples >> exampleStringToLocatorWithPath [
	<gtExample>
	self append: self childPathSegment to: self parentWithPath assertEquals: self parentWithPath / self childPathSegment
]

{ #category : #examples }
RlAppendExamples >> exampleStringToReference [
	<gtExample>
	self append: self childPathSegment to: self parentReference assertEquals: self parentReference / self childPathSegment
]

{ #category : #accessing }
RlAppendExamples >> parentPathSegment [
	^ 'pSub'
]

{ #category : #accessing }
RlAppendExamples >> parentReference [
	^ self parentWithoutPath resolve
]

{ #category : #accessing }
RlAppendExamples >> parentWithPath [
	^ self parentWithoutPath / self parentPathSegment.
]

{ #category : #accessing }
RlAppendExamples >> parentWithPath: aString [
	^ self parentWithoutPath / aString.
]

{ #category : #accessing }
RlAppendExamples >> parentWithoutPath [
	^ FileLocator home.
]
