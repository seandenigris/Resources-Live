private
locationFor: filename

	| sameFilename result |
	sameFilename := self folder / filename.
	result := sameFilename exists
		ifFalse: [ sameFilename ]
		ifTrue: [ 
			| uniqueBase |
			uniqueBase := self nextID asString, ' (', sameFilename base, ')'.
			self folder / uniqueBase, sameFilename extension ].
	self assert: result exists not.
	^ result