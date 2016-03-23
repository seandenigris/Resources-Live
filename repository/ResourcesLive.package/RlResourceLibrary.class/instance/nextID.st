private
nextID
	self lastID: self lastID + 1.
	^ self lastID printStringHex