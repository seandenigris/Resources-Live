actions
moveFileTo: reference
	self file moveTo: reference.
	self file: reference. "This line is needed due to FS bug: https://github.com/pharo-project/pharo/issues/4453"