Extension { #name : #DbTDomainObject }

{ #category : #'*ResourcesLive' }
DbTDomainObject >> resourceLibrary [

	^ RlResourceLibrary uniqueInstance
]

{ #category : #'*ResourcesLive' }
DbTDomainObject >> resources [

	^ self
		propertyAt: #resources
		ifAbsentPut: [ IdentitySet new ]
]

{ #category : #'*ResourcesLive' }
DbTDomainObject >> resources: aCollection [

	^ self
		propertyAt: #resources
		put: aCollection
]

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
