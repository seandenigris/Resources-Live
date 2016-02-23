private
locationFor: filename

	| result |
	result := self class folder / filename.
	self assert: result exists not.
	^ result