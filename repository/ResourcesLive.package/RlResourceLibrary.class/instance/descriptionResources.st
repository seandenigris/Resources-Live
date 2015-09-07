magritte
descriptionResources
	<magritteDescription>
	<gtInspectorPresentationOrder: 10>
		
	^ MAToManyRelationDescription new
			accessor: #resources;
			label: 'Resources';
			priority: 100;
			default: OrderedCollection new; "no reason for an OC specifically, except it already is; via #initialize"
			"classes: { RlEmail };"
			glmPresentation: #list;
			yourself