importing
import: resource moving: shouldMove

	| destinationFile sourceFile |
	sourceFile := resource asRlResource file.
	destinationFile := self locationFor: sourceFile basename.	
	self assert: destinationFile exists not.
	shouldMove
		ifTrue: [	sourceFile moveTo: destinationFile ]
		ifFalse: [	sourceFile copyTo: destinationFile ].
	resource file: destinationFile.
	^ resources add: resource.