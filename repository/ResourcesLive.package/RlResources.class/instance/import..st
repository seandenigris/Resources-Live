as yet unclassified
import: aFileReference

	| destination resource |
	destination := self locationFor: aFileReference basename.	
	OSProcess command: 'mv ', aFileReference asCliString, ' ', destination asCliString.
	resource := "Resource on:" destination.
	^ resources add: resource.