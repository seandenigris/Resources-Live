as yet unclassified
newRecordClassNamed: aSymbol inPackage: packageName
	| reader fieldNames |
	reader := NeoCSVReader on: self file readStream.
	fieldNames := reader readHeader.
	Object subclass: aSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	package: packageName