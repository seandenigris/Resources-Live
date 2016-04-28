private
folder: aFolder
	self resources do: [ :e | e moveInto: aFolder ].
	folder := aFolder