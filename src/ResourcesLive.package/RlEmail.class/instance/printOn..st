printing
printOn: aStream
	aStream
		nextPutAll: 'Email ';
		nextPut: $(;
		nextPutAll: self properFilename;
		nextPut: $)