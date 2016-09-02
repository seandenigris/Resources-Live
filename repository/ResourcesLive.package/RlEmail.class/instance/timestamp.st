accessing
timestamp
	^ timestamp ifNil: [ timestamp := self mailMessage timestamp ]