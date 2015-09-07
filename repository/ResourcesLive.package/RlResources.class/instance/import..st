as yet unclassified
import: resource

	| destinationFile sourceFile |
	sourceFile := resource file.
	destinationFile := self locationFor: sourceFile basename.	
	sourceFile moveTo: destinationFile.
	resource file: destinationFile.
	^ resources add: resource.