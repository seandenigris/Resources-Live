printing
printOn: aStream
	aStream
		nextPutAll: self description;
		nextPutAll: ' @ ';
		nextPutAll: self location