importing
importInPlace: resourceable
	"Do not move or copy the file"

	| resource |
	resource := resourceable asRlResource.
	resource importTimestamp: DateAndTime now translateToUTC.
	^ resources add: resource.