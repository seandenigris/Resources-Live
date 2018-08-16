printing
printOn: aStream
	aStream
		nextPutAll: self className;
		nextPut: $(.
	self file ifNotNil: [ :f | aStream nextPutAll: f basename ].
	aStream nextPut: $)