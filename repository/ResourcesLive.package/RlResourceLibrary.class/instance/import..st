as yet unclassified
import: resource

	| destinationFile sourceFile |
	sourceFile := resource file.
	destinationFile := self locationFor: sourceFile basename.	
	self deny: destinationFile exists.
	sourceFile moveTo: destinationFile.
	resource file: destinationFile.
	^ resources add: resource.