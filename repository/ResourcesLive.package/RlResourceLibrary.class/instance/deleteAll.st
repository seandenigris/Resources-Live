accessing
deleteAll
	self resources do: [ :e | e file delete ].
	self folder delete