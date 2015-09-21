importing
import: resourceable

	| destinationFile sourceFile resource |
	resource := resourceable asRlResource.
	sourceFile := resource file.
	destinationFile := self locationFor: sourceFile basename.	
	self assert: destinationFile exists not.
	sourceFile moveTo: destinationFile.
	resource file: destinationFile.
	^ resources add: resource.