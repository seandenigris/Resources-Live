accessing
metadata
	^ metadata ifNil: [ metadata := OrderedCollection new ]