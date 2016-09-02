accessing
mailMessage
	| contents eml |
	eml := self file.
	contents := eml
		readStreamDo: [ :str | 
			str
				converter: ISO88592TextConverter new;
				upToEnd ].
	^ MailMessage from: contents