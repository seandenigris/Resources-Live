instance creation
on: file
	| class |
	class := self allSubclasses
		detect: [ :e | e fileExtensions includes: file extension ]
		ifNone: [ self ].
	^ class new
		file: file;
		yourself.