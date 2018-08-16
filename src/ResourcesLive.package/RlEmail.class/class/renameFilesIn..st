utilities
renameFilesIn: folder
	| filesToRename email |
	filesToRename := folder files
		select: [ :f | f base isAllDigits and: [ f extension = 'eml' ] ].
	filesToRename
		do: [ :file | 
			email := RlEmail on: file.
			[ file verifiedMoveTo: folder / email properFilename ]
				on: FileExists
				do: [ :e | 
					| n uniqueName |
					n := e reference asFileReference.
					uniqueName := n base , (Time now asString select: #isDigit) , '_copy.eml'.
					(file isMD5Equal: n)
						ifTrue: [ file moveTo: (n parent / 'Duplicates') ensureCreateDirectory / uniqueName ]
						ifFalse: [ file verifiedMoveTo: n parent / uniqueName ] ] ].
	^ folder filesMatching: '*_copy.eml'