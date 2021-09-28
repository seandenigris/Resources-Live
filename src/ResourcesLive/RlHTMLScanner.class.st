Class {
	#name : 'RlHTMLScanner',
	#superclass : 'SmaCCScanner',
	#category : 'ResourcesLive-EPUB'
}

{ #category : 'generated' }
RlHTMLScanner >> emptySymbolTokenId [
	^ 47
]

{ #category : 'generated' }
RlHTMLScanner >> errorTokenId [
	^ 48
]

{ #category : 'generated' }
RlHTMLScanner >> scan1 [
	[ self step.
	currentCharacter == Character space ] whileTrue.
	currentCharacter == $"
		ifTrue:
			[ ^ self scan1X4 ].
	currentCharacter == $#
		ifTrue:
			[ ^ self scan1X1 ].
	currentCharacter == $'
		ifTrue:
			[ ^ self scan1X3 ].
	currentCharacter isDigit
		ifTrue:
			[ ^ self scan1X2 ].
	((currentCharacter between: $+ and: $/)
		or: [ (currentCharacter between: $: and: $;)
				or: [ ('=?' includes: currentCharacter)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ])
		ifTrue: [ ^ self scan2 ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan10 [
	self recordMatch: #(10).
	self step.
	currentCharacter == $!
		ifTrue:
			[ ^ self scan10X1 ].
	currentCharacter == $%
		ifTrue: [ ^ self scan22 ].
	currentCharacter == $?
		ifTrue: [ self step.
			currentCharacter == $?
				ifTrue: [ ^ self scan25 ].
			currentCharacter == $x
				ifTrue: [ self step.
					currentCharacter == $?
						ifTrue: [ ^ self scan25 ].
					currentCharacter == $m
						ifTrue: [ self step.
							currentCharacter == $?
								ifTrue: [ ^ self scan25 ].
							currentCharacter == $l
								ifTrue: [ ^ self scan26 ] ] ].
			^ self scan24 ].
	currentCharacter == $s
		ifTrue: [ self step.
			currentCharacter == $c
				ifTrue: [ (self scanForString: 'ript')
						ifTrue: [ ^ self scan29 ].
					^ self reportLastMatch ].
			currentCharacter == $t
				ifTrue: [ (self scanForString: 'yle')
						ifTrue: [ ^ self scan30 ] ] ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan10X1 [
	self step.
	currentCharacter == $-
		ifTrue: [ self step.
			currentCharacter == $-
				ifTrue: [ ^ self scan13 ].
			currentCharacter == $>
				ifTrue: [ ^ self scan12 ].
			^ self scan11 ].
	currentCharacter == $>
		ifTrue: [ ^ self scan12 ].
	currentCharacter == $[
		ifTrue: [ self step.
			currentCharacter == $>
				ifTrue: [ ^ self scan17 ].
			currentCharacter == $C
				ifTrue: [ self step.
					currentCharacter == $>
						ifTrue: [ ^ self scan17 ].
					currentCharacter == $D
						ifTrue: [ self step.
							currentCharacter == $>
								ifTrue: [ ^ self scan17 ].
							currentCharacter == $A
								ifTrue: [ self step.
									currentCharacter == $>
										ifTrue: [ ^ self scan17 ].
									currentCharacter == $T
										ifTrue: [ self step.
											currentCharacter == $>
												ifTrue: [ ^ self scan17 ].
											currentCharacter == $A
												ifTrue: [ self step.
													currentCharacter == $>
														ifTrue: [ ^ self scan17 ].
													currentCharacter == $[
														ifTrue: [ ^ self scan19 ] ] ] ] ] ].
			currentCharacter == $]
				ifTrue: [ ^ self scan18 ].
			^ self scan16 ].
	^ self scan11
]

{ #category : 'generated' }
RlHTMLScanner >> scan11 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ ^ self scan12 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan12 [
	[ self recordMatch: #(5).
	self step.
	currentCharacter == $> ] whileTrue.
	^ self scan11
]

{ #category : 'generated' }
RlHTMLScanner >> scan13 [
	[ self step.
	currentCharacter == $-
		ifTrue: [ ^ self scan14 ].
	currentCharacter == $>
		ifTrue: [ ^ self scan15 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan14 [
	self step.
	currentCharacter == $-
		ifTrue: [ [ self step.
			currentCharacter == $- ] whileTrue.
			currentCharacter == $>
				ifTrue: [ self recordMatch: #(1 5).
					self step.
					currentCharacter == $-
						ifTrue: [ ^ self scan14 ].
					currentCharacter == $>
						ifTrue: [ ^ self scan15 ] ].
			^ self scan13 ].
	currentCharacter == $>
		ifTrue: [ ^ self scan15 ].
	^ self scan13
]

{ #category : 'generated' }
RlHTMLScanner >> scan15 [
	[ self recordMatch: #(5).
	self step.
	currentCharacter == $-
		ifTrue: [ ^ self scan14 ].
	currentCharacter == $> ] whileTrue.
	^ self scan13
]

{ #category : 'generated' }
RlHTMLScanner >> scan16 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ ^ self scan17 ].
	currentCharacter == $]
		ifTrue: [ ^ self scan18 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan17 [
	[ self recordMatch: #(5).
	self step.
	currentCharacter == $> ] whileTrue.
	currentCharacter == $]
		ifTrue: [ ^ self scan18 ].
	^ self scan16
]

{ #category : 'generated' }
RlHTMLScanner >> scan18 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(2 5).
			self step.
			currentCharacter == $>
				ifTrue: [ ^ self scan17 ].
			currentCharacter == $]
				ifTrue: [ ^ self scan18 ].
			^ self scan16 ].
	currentCharacter == $] ] whileTrue.
	^ self scan16
]

{ #category : 'generated' }
RlHTMLScanner >> scan19 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ ^ self scan20 ].
	currentCharacter == $]
		ifTrue: [ ^ self scan21 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan1X1 [
	[ self recordMatch: #(21).
	self step.
	currentCharacter == Character space
		ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	currentCharacter isDigit
		or: [ (currentCharacter between: $A and: $F)
				or: [ currentCharacter between: $a and: $f ] ] ] whileTrue.
	(currentCharacter == $#
		or: [ (currentCharacter between: $+ and: $/)
				or: [ (currentCharacter between: $: and: $;)
						or: [ ('=?' includes: currentCharacter)
								or: [ (currentCharacter between: $G and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $g and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan2 ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan1X2 [
	[ self recordMatch: #(21).
	self step.
	currentCharacter isDigit ] whileTrue.
	(currentCharacter == Character space or: [ currentCharacter == $% ])
		ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	(currentCharacter == $#
		or: [ (currentCharacter between: $+ and: $/)
				or: [ (currentCharacter between: $: and: $;)
						or: [ ('=?' includes: currentCharacter)
								or: [ (currentCharacter between: $A and: $Z)
										or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ])
		ifTrue: [ ^ self scan2 ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan1X3 [
	[ self step.
	currentCharacter == $'
		ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	currentCharacter <= $&
		or: [ (currentCharacter between: $( and: $;)
				or: [ currentCharacter >= $= ] ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan1X4 [
	[ self step.
	currentCharacter == $"
		ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	currentCharacter <= $!
		or: [ (currentCharacter between: $# and: $;)
				or: [ currentCharacter >= $= ] ] ] whileTrue.
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan2 [
	[ self recordMatch: #(21).
	self step.
	currentCharacter == Character space
		ifTrue: [ ^ self recordAndReportMatch: #(21) ].
	currentCharacter == $#
		or: [ (currentCharacter between: $+ and: $;)
				or: [ ('=?' includes: currentCharacter)
						or: [ (currentCharacter between: $A and: $Z)
								or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ] ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan20 [
	[ self recordMatch: #(5).
	self step.
	currentCharacter == $> ] whileTrue.
	currentCharacter == $]
		ifTrue: [ ^ self scan21 ].
	^ self scan19
]

{ #category : 'generated' }
RlHTMLScanner >> scan21 [
	self step.
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(2 5).
			self step.
			currentCharacter == $>
				ifTrue: [ ^ self scan20 ].
			currentCharacter == $]
				ifTrue: [ ^ self scan21 ].
			^ self scan19 ].
	currentCharacter == $]
		ifTrue: [ [ self step.
			currentCharacter == $>
				ifTrue: [ self recordMatch: #(2 4 5).
					self step.
					currentCharacter == $>
						ifTrue: [ ^ self scan20 ].
					currentCharacter == $]
						ifTrue: [ ^ self scan21 ].
					^ self scan19 ].
			currentCharacter == $] ] whileTrue ].
	^ self scan19
]

{ #category : 'generated' }
RlHTMLScanner >> scan22 [
	[ self step.
	currentCharacter == $%
		ifTrue: [ ^ self scan23 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan23 [
	[ self step.
	currentCharacter == $% ] whileTrue.
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(6).
			self step.
			currentCharacter == $%
				ifTrue: [ ^ self scan23 ] ].
	^ self scan22
]

{ #category : 'generated' }
RlHTMLScanner >> scan24 [
	[ self step.
	currentCharacter == $?
		ifTrue: [ ^ self scan25 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan25 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(6).
			self step.
			currentCharacter == $?
				ifTrue: [ ^ self scan25 ].
			^ self scan24 ].
	currentCharacter == $? ] whileTrue.
	^ self scan24
]

{ #category : 'generated' }
RlHTMLScanner >> scan26 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ ^ self scan27 ].
	currentCharacter == $?
		ifTrue: [ ^ self scan28 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan27 [
	[ self recordMatch: #(3).
	self step.
	currentCharacter == $> ] whileTrue.
	currentCharacter == $?
		ifTrue: [ ^ self scan28 ].
	^ self scan26
]

{ #category : 'generated' }
RlHTMLScanner >> scan28 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ self recordMatch: #(3 6).
			self step.
			currentCharacter == $>
				ifTrue: [ ^ self scan27 ].
			currentCharacter == $?
				ifTrue: [ ^ self scan28 ].
			^ self scan26 ].
	currentCharacter == $? ] whileTrue.
	^ self scan26
]

{ #category : 'generated' }
RlHTMLScanner >> scan29 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ [ self recordMatch: #(8).
			self step.
			currentCharacter == $> ] whileTrue.
			^ self scan29 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan3 [
	[ self step.
	currentCharacter == $<
		ifTrue: [ ^ self scan4 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan30 [
	[ self step.
	currentCharacter == $>
		ifTrue: [ [ self recordMatch: #(9).
			self step.
			currentCharacter == $> ] whileTrue.
			^ self scan30 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan4 [
	[ self step.
	currentCharacter == $/
		ifTrue: [ self step.
			currentCharacter == $<
				ifTrue: [ ^ self scan4 ].
			currentCharacter == $>
				ifTrue: [ self recordMatch: #(18).
					self step.
					currentCharacter == $<
						ifTrue: [ ^ self scan4 ].
					^ self scan3 ].
			currentCharacter == $s
				ifTrue: [ self step.
					currentCharacter == $<
						ifTrue: [ ^ self scan4 ].
					currentCharacter == $c
						ifTrue: [ self step.
							currentCharacter == $<
								ifTrue: [ ^ self scan4 ].
							currentCharacter == $r
								ifTrue: [ self step.
									currentCharacter == $<
										ifTrue: [ ^ self scan4 ].
									currentCharacter == $i
										ifTrue: [ self step.
											currentCharacter == $<
												ifTrue: [ ^ self scan4 ].
											currentCharacter == $p
												ifTrue: [ self step.
													currentCharacter == $<
														ifTrue: [ ^ self scan4 ].
													currentCharacter == $t
														ifTrue: [ self step.
															currentCharacter == $<
																ifTrue: [ ^ self scan4 ].
															currentCharacter == $>
																ifTrue: [ self recordMatch: #(17).
																	self step.
																	currentCharacter == $<
																		ifTrue: [ ^ self scan4 ] ] ] ] ] ] ] ].
			^ self scan3 ].
	currentCharacter == $< ] whileTrue.
	^ self scan3
]

{ #category : 'generated' }
RlHTMLScanner >> scan5 [
	[ self step.
	currentCharacter == $<
		ifTrue: [ ^ self scan6 ].
	true ] whileTrue
]

{ #category : 'generated' }
RlHTMLScanner >> scan6 [
	[ self step.
	currentCharacter == $/
		ifTrue: [ self step.
			currentCharacter == $<
				ifTrue: [ ^ self scan6 ].
			currentCharacter == $>
				ifTrue: [ self recordMatch: #(20).
					self step.
					currentCharacter == $<
						ifTrue: [ ^ self scan6 ].
					^ self scan5 ].
			currentCharacter == $s
				ifTrue: [ self step.
					currentCharacter == $<
						ifTrue: [ ^ self scan6 ].
					currentCharacter == $t
						ifTrue: [ self step.
							currentCharacter == $<
								ifTrue: [ ^ self scan6 ].
							currentCharacter == $y
								ifTrue: [ self step.
									currentCharacter == $<
										ifTrue: [ ^ self scan6 ].
									currentCharacter == $l
										ifTrue: [ self step.
											currentCharacter == $<
												ifTrue: [ ^ self scan6 ].
											currentCharacter == $e
												ifTrue: [ self step.
													currentCharacter == $<
														ifTrue: [ ^ self scan6 ].
													currentCharacter == $>
														ifTrue: [ self recordMatch: #(19).
															self step.
															currentCharacter == $<
																ifTrue: [ ^ self scan6 ] ] ] ] ] ] ].
			^ self scan5 ].
	currentCharacter == $< ] whileTrue.
	^ self scan5
]

{ #category : 'generated' }
RlHTMLScanner >> scan7 [
	self step.
	currentCharacter == Character cr
		ifTrue: [ ^ self scan9 ].
	currentCharacter == $<
		ifTrue: [ ^ self scan10 ].
	((currentCharacter between: Character tab and: Character lf)
		or: [ currentCharacter == Character space ])
		ifTrue: [ ^ self scan8 ].
	true
		ifTrue: [ [ self recordMatch: #(11).
			self step.
			currentCharacter ~~ $< ] whileTrue ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan8 [
	[ self recordMatch: #(7 11).
	self step.
	currentCharacter == Character cr
		ifTrue: [ ^ self scan9 ].
	(currentCharacter between: Character tab and: Character lf)
		or: [ currentCharacter == Character space ] ] whileTrue.
	(currentCharacter <= Character backspace
		or: [ (currentCharacter between: Character pageUp and: Character newPage)
				or: [ (currentCharacter
						between: (Character value: 14)
						and: Character arrowDown)
						or: [ (currentCharacter between: $! and: $;)
								or: [ currentCharacter >= $= ] ] ] ])
		ifTrue: [ [ self recordMatch: #(11).
			self step.
			currentCharacter ~~ $< ] whileTrue ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scan9 [
	self recordMatch: #(11).
	self step.
	currentCharacter == Character lf
		ifTrue: [ ^ self scan8 ].
	(currentCharacter <= Character tab
		or: [ (currentCharacter between: Character pageUp and: $;)
				or: [ currentCharacter >= $= ] ])
		ifTrue: [ [ self recordMatch: #(11).
			self step.
			currentCharacter ~~ $< ] whileTrue ].
	^ self reportLastMatch
]

{ #category : 'generated' }
RlHTMLScanner >> scanForToken [
	scope == #TAG
		ifTrue: [ self step.
			currentCharacter == $/
				ifTrue: [ self recordMatch: #(14).
					self step.
					currentCharacter == $>
						ifTrue: [ ^ self recordAndReportMatch: #(13) ].
					^ self reportLastMatch ].
			currentCharacter == $=
				ifTrue: [ ^ self recordAndReportMatch: #(15) ].
			currentCharacter == $>
				ifTrue: [ ^ self recordAndReportMatch: #(12) ].
			true
				ifTrue: [ [ self recordMatch: #(16).
					self step.
					true ] whileTrue ].
			^ self reportLastMatch ].
	scope == #STYLE
		ifTrue: [ ^ self scan5 ].
	scope == #default
		ifTrue: [ ^ self scan7 ].
	scope == #ATTVALUE
		ifTrue: [ ^ self scan1 ].
	scope == #SCRIPT
		ifTrue: [ ^ self scan3 ].
	^ self reportLastMatch
]
