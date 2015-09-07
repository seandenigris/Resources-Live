*ResourcesLive-Morphic
asMorph
	
	| morph openButton builder controls |
	builder := UITheme builder.
	self flag: 'Looks like we were using LivingCode here'.
	morph := "UserObject"Morph on: self.
	openButton := builder newButtonFor: self action: #open label: 'Open file' help: ''.
"	pauseButton := builder newButtonFor: self action: #pause label: 'Pause' help: ''."
	controls := builder newRow: { openButton }.
	morph addControls: controls.
	^ morph.