tokens
temporary

	^ self new
		folder: (FileLocator imageDirectory / DateAndTime now asString asLegalSelector) ensureCreateDirectory;
		yourself