converting
convert: inputFile to: outputFile

	| commandTemplate command returnValue |
	commandTemplate := '/usr/local/bin/pdfimages -j "{input}" "{output}"'.
	command := commandTemplate
		format:
			{(#input -> inputFile fullName).
			(#output -> outputFile)} asDictionary.
	returnValue := LibC system: command.
	self assert: returnValue = 0