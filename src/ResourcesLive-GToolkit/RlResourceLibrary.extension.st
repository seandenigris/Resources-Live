Extension { #name : #RlResourceLibrary }

{ #category : #'*ResourcesLive-GToolkit' }
RlResourceLibrary >> gtViewRecentResourcesOn: aView [
	<gtView>
	^ (self gtViewResources: [ self resources last: 25 ] on: aView)
		title: 'Recent' translated;
		priority: 10
]

{ #category : #'*ResourcesLive-GToolkit' }
RlResourceLibrary >> gtViewResources: aBlock on: aView [
	
	^ aView columnedList
		items: aBlock;
		column: 'Type' text: [ :res | res class name allButFirst: 2 ] width: 125;
		column: 'File' text: [ :res | res file fullName ];
		actionUpdateButtonTooltip: 'Update'.
]

{ #category : #'*ResourcesLive-GToolkit' }
RlResourceLibrary >> gtViewResourcesOn: aView [
	<gtView>
	^ (self gtViewResources: [ self resources ] on: aView)
		title: 'Resources' translated;
		priority: 5
]

{ #category : #'*ResourcesLive-GToolkit' }
RlResourceLibrary class >> gtViewSingletonOn: aView [
	<gtClassView>
	^ aView forward
		title: 'Singleton';
		priority: 100;
		object: [ self uniqueInstance ];
		view: #gtViewResourcesOn:
]
