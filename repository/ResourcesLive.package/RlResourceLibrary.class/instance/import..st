as yet unclassified
import: resource

	| destinationFile sourceFile |
	sourceFile := resource file.
	destinationFile := self locationFor: sourceFile basename.	
	self assert: destinationFile exists not.
	sourceFile moveTo: destinationFile.
	resource file: destinationFile.
	^ resources add: resource.