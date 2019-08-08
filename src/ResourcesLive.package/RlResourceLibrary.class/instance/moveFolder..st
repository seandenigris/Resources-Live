private
moveFolder: aFolder
	self resources do: [ :e | e moveFileInto: aFolder ].
	self basicFolder: aFolder