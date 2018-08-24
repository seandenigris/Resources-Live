converting
convert
	| p |
	p := PipeableOSProcess waitForCommand: self command.
	self assert: p succeeded