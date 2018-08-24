private
current
	^ current ifNil: [ self installedConverter ]