accessing
displayString
	| msg |
	msg := self mailMessage.
	^ String
		streamContents: [ :str | 
			self timestamp asDate yyyymmdd.
			str space.
			self timestamp asTime printMinutes.
			str space.
			str nextPutAll: msg subject ].