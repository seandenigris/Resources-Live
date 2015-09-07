as yet unclassified
importAs: filename after: aBlock

	| target |
	self flag: 'ultimately, there may be no need to pass filename in, but I''m too afraid to remove it just yet'.
	target := RlResourceLibrary library locationFor: filename.
	aBlock value: target.
	resources add: target.