as yet unclassified
editNew

	| newFile |
	OSProcess command: 'cp "{1}" "{2}"'.
	self applescriptTemplateFile copyTo: self resourceDirectory.
	newFile := self resourceDirectory directoryEntryFor: self applescriptTemplateFile name.
	ApplescriptEditor app
		open: newFile;
		activate.