Extension { #name : #MailMessage }

{ #category : #'*ResourcesLive' }
MailMessage >> asMarkdown [
	
	^ self bodyRlHtml ifNotNil: #asMarkdown.
]

{ #category : #'*ResourcesLive' }
MailMessage >> asPlainText [
	
	^ self asMarkdown ifNil: [ self bodyTextFormatted ]
]

{ #category : #'*ResourcesLive' }
MailMessage >> bodyRlHtml [
	
	| htmlString htmlPart |
	htmlPart := self htmlPart ifNil: [ ^ nil ].
	htmlString := htmlPart bodyText.
	^ RlHTML fromString: htmlString
]

{ #category : #'*ResourcesLive' }
MailMessage >> parseParts [
	"private -- parse the parts of the message and store them into a collection"

	"If this is not multipart, store an empty collection"

	| parseStream msgStream messages separator currentLine |
	self body isMultipart
		ifFalse: [ parts := #().
			^ self ].

	"If we can't find a valid separator, handle it as if the message is not multipart"
	separator := self attachmentSeparator.
	separator
		ifNil: [ self traceCr: 'Ignoring bad attachment separater'.
			parts := #().
			^ self ].
	separator := '--' , separator trimRight.
	parseStream := self bodyText readStream.
	msgStream := ZnFastLineReader on: parseStream.

	"Throw away everything up to and including the first separator"
	currentLine := ''.
	[ currentLine trimRight = separator or: [ "Match the separator" currentLine trimRight = (separator , '--') ] ]
		whileFalse: [ currentLine := msgStream nextLine ].

	"Skip the separator"
	currentLine := msgStream nextLine.

	"Extract each of the multi-parts as strings"
	messages := OrderedCollection new.
	[ parseStream atEnd ] whileFalse: [ | message |
		message := String streamContents: [ :stream |
			[ currentLine trimRight = separator or: [ "Match the separator" currentLine trimRight = (separator , '--') ] ]
				whileFalse: [
					stream 
						nextPutAll: currentLine;
						nextPut: Character lf.
					currentLine := msgStream nextLine ].
		].
		
		messages add: message.
		"Skip the separator"
		currentLine := msgStream nextLine
	].
	parts := messages collect: [ :e | MailMessage fromRfc822: e ]
]
