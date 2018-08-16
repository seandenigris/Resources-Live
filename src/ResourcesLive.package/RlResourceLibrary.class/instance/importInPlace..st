importing
importInPlace: resourceable

	| resource |
	resource := resourceable asRlResource.
	resource importTimestamp: DateAndTime now translateToUTC.
	^ resources add: resource.