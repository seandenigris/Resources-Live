Class {
	#name : #RlAppleEmail,
	#superclass : #RlEmail,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlAppleEmail class >> fileExtensions [
	^ #('emlx')
]

{ #category : #accessing }
RlAppleEmail >> mailMessage [
	| contents emlx headerSize xmlFooterHeader lines messageLines messageString headerStart |
	emlx := self file.
	emlx exists ifFalse: [ ^ nil ].
	
	headerSize := 1.
	xmlFooterHeader := '<?xml version="1.0" encoding="UTF-8"?>'.
	
	contents := emlx readStreamEncoded: #iso88592 do: [ :str |
		str encoder beLenient. 
		str upToEnd ].
		
	lines := contents lines.
	headerStart := lines findLast: [ :e | e = xmlFooterHeader ].
	messageLines := lines copyFrom: 1 + headerSize to: headerStart - 1.
	messageString := messageLines joinUsing: Character lf.
	
	^ MailMessage fromRfc822: messageString
	
	"Inspired by this SO post about the EMLX format: https://stackoverflow.com/a/15712934 which has lots of additional information that might be useful in the future about the XML footer format"
]
