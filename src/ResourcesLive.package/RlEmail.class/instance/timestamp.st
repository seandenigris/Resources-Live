accessing
timestamp
	^ timestamp ifNil: [ self mailMessage timestamp ]