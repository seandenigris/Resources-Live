tokens
temporary

	^ self new
		basicFolder: (FileLocator imageDirectory / DateAndTime now asString asFilename) ensureCreateDirectory;
		yourself