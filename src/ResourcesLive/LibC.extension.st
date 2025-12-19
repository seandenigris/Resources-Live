Extension { #name : 'LibC' }

{ #category : '*ResourcesLive' }
LibC class >> runWaitAndAssert: aString [
	| returnValue |
	returnValue := self system: aString.
	self assert: returnValue = 0
]
