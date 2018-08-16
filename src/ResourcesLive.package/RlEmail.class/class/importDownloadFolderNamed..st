utilities
importDownloadFolderNamed: folderName
	| folder archiveRootFolder emails |
	folder := FileLocator home / 'Downloads' / 'Email Archive' / 'Downloads' / folderName.
	archiveRootFolder := FileLocator home / 'Downloads' / 'Email Archive' / 'Archive'.
	emails := (folder filesMatching: '*.eml') collect: [ :file | RlEmail on: file ].
	emails do: [ :e | e metadata add: folderName ].
	emails
		collect: [ :e | 
			| targetFolder target |
			targetFolder := archiveRootFolder / e timestamp year asString.
			target := targetFolder / e file basename.
			e file verifiedMoveTo: target.
			e file: target ].
	emails do: [ :e | RlResourceLibrary uniqueInstance importInPlace: e ].
	^ RlResourceLibrary uniqueInstance resources select: [ :e | e metadata includes: folderName ]