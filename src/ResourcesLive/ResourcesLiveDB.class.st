"
Because I am used as a component of other systems, which require me to be persisted together with their objects in order to preserve references in the object graph, I must be manually enabled via `self enable`.
"
Class {
	#name : #ResourcesLiveDB,
	#superclass : #SpFileDatabase,
	#classInstVars : [
		'backupDirectoryParent'
	],
	#category : 'ResourcesLive-Persistence'
}

{ #category : #accessing }
ResourcesLiveDB class >> backupDirectoryParent [
	^ backupDirectoryParent ifNil: [ FileLocator dynabookData / 'ResourcesLive' ]
]

{ #category : #accessing }
ResourcesLiveDB class >> backupDirectoryParent: folder [
	backupDirectoryParent := folder
]

{ #category : #protocol }
ResourcesLiveDB class >> initialize [
	self setUp.
]

{ #category : #'override in subclasses' }
ResourcesLiveDB class >> repositories [

	^ { RlResourceLibrary uniqueInstance }.
]

{ #category : #'override in subclasses' }
ResourcesLiveDB class >> restoreRepositories: someRepositories [

	RlResourceLibrary restoreFrom: someRepositories first.
]
