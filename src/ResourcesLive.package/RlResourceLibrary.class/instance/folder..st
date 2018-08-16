private
folder: aFolder
	self resources do: [ :e | e moveFileInto: aFolder ].
	folder := aFolder