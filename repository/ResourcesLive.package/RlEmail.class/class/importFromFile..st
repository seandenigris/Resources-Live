as yet unclassified
importFromFile: aString 
	| instance |
	instance := self new
		file: aString asFileReference;
		yourself.
	RlResourceLibrary uniqueInstance import: instance.