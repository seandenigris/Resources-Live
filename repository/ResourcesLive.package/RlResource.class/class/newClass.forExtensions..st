as yet unclassified
newClass: aSymbol forExtensions: aCollection
	"self newClass: #RlCsvFile forExtensions: #('csv')"
	| newClass fileExtensionsMethod targetPackage |
	targetPackage := 'ResourcesLive-Core'. "Was `self package name`, but evaluating the method comment from Nautilus puts newClass in wrong category (one level too high)"
	newClass := RlResource subclass: aSymbol
			instanceVariableNames: ''
			classVariableNames: ''
			package: targetPackage.
	fileExtensionsMethod := 'fileExtensions
	^ ', aCollection asArray asString.
	newClass class compile: fileExtensionsMethod classified: 'accessing'.
	^ newClass