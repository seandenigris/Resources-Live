actions
moveFileTo: reference
	self file moveTo: reference.
	self file: reference. "Needed due to FS bug when moving FR to a FL"