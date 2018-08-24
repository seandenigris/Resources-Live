private
command

	^ self commandTemplate format: {
			(#input -> self inputFile asFileReference fullName).
			(#output -> self outputFile asFileReference fullName) } asDictionary.