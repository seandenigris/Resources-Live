accessing
outputFile
	^ outputFile ifNil: [ outputFile := Tempfile new ]