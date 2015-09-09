importing
importFile: file

	| resource |
	resource := RlResource on: file.
	^ self import: resource.