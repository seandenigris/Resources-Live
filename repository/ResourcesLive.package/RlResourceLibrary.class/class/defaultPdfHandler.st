as yet unclassified
defaultPdfHandler

	^ ExternalDropHandler
			type: nil
			extension: 'pdf'
			action: [ :stream :pasteUp :event | self handleDroppedFileNamed: stream name ].