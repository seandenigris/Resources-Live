accessing
properFilename
	| msg rawFilename safeFilename filenameNoSpaces extension |
	msg := self mailMessage.
	"Makes filename too long:
	fromTokens := MailAddressTokenizer tokensIn: msg from.
	nameToken := fromTokens detect: [ :t | t type = #QuotedString ].
	sender := nameToken text trimBoth: [ :c | c = $DoubleQuote ]."
	rawFilename := String
		streamContents: [ :str | 
			self timestamp asDate printOn: str format: #(3 2 1 0 1 2 2).
			str space.
			self timestamp asTime print24: true on: str.
			str space.
			"str nextPutAll: sender.
		str space."
			str nextPutAll: msg subject ].
	safeFilename := rawFilename
		select: [ :c | c isAlphaNumeric or: [ c = $_ or: [ c = Character space ] ] ].
	filenameNoSpaces := safeFilename withBlanksCondensed
		copyReplaceAll: ' '
		with: '_'.
	extension := '.eml'.
	^ (filenameNoSpaces truncateTo: 31 - extension size) , extension