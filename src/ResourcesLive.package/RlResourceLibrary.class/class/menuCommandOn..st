world menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #'Resources Inspect')
		order: 0.30;
		action: [ self uniqueInstance inspect ];
		icon: (Smalltalk ui icons iconNamed: #toolsIcon). 