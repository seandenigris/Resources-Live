as yet unclassified
printOn: aStream
	aStream
		nextPutAll: self className;
		nextPut: $(;
		nextPutAll: self file basename;
		nextPut: $)