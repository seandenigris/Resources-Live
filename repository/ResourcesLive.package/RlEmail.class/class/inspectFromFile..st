as yet unclassified
inspectFromFile: aString 
	| instance |
	instance := self new
		file: aString asFileReference;
		yourself.
	instance inspect.