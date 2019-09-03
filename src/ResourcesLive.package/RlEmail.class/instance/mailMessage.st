accessing
mailMessage
	| contents eml |
	eml := self file.
	contents := eml readStreamEncoded: #iso88592 do: [ :str |
		str encoder beLenient. 
		str upToEnd ].
	^ MailMessage fromRfc822: contents