as yet unclassified
asArraysOfStrings
	^ self file readStreamDo: [ :str | 
		| r |
		r := NeoCSVReader on: str .
		r upToEnd ].