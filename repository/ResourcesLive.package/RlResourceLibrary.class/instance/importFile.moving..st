importing
importFile: file moving: shouldMove

	| resource |
	resource := RlResource on: file.
	^ self import: resource moving: shouldMove.