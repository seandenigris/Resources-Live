as yet unclassified
inspectFromFile: aString 
	| instance |
	instance := self new
		file: aString asFileReference;
		yourself.
	RlResourceLibrary library import: instance.