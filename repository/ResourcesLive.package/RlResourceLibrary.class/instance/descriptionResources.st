magritte
descriptionResources
	<magritteDescription>
	<gtInspectorPresentationOrder: 10>
		
	^ MAToManyRelationDescription new
			accessor: #resources;
			label: 'Resources';
			priority: 100;
			default: OrderedCollection new; "no reason except it already is; via #initialize"
			"classes: { RlEmail };"
			gtPresentation: [ :a | self gtInspectorResourcesIn: a ];
			yourself