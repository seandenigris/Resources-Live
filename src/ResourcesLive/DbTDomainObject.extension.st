Extension { #name : #DbTDomainObject }

{ #category : #'*ResourcesLive' }
DbTDomainObject >> resourcesDescription [
	<magritteDescription>
	
	^ MAToManyRelationDescription new
			accessor: #resources;
			priority: 650;
			default: IdentitySet new;
			classes: RlResource withAllSubclasses;
			gtSearchSource: (MessageSend receiver: self selector: #resourceLibrary);
			yourself
]
