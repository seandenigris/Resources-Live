as yet unclassified
newRecordClassNamed: aSymbol inPackage: packageName
	| reader fieldNames |
	self flag: 'Seems incomplete; are fields supposed to be set up automatically?'.
	reader := NeoCSVReader on: self file readStream.
	fieldNames := reader readHeader.
	Object subclass: aSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	package: packageName