private
nextID
	^ LastID := LastID
		ifNotNil: [ LastID + 1 ]
		ifNil: [ 1 ]