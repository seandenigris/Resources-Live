Class {
	#name : #RlWordTableRow,
	#superclass : #Object,
	#instVars : [
		'pythonInstance'
	],
	#category : #'ResourcesLive-MS Word'
}

{ #category : #accessing }
RlWordTableRow class >> fromProxy: aPBProxy [

	^ self new
		pythonInstance: aPBProxy;
		yourself
]

{ #category : #accessing }
RlWordTableRow >> at: columnIndex put: aString [

	self newCommandFactory
		bindingAt: #columnIndex put: columnIndex - 1;
		bindingAt: #aString put: aString;
		source: 'self.cells[columnIndex].text = aString';
		sendAndWait.
]

{ #category : #accessing }
RlWordTableRow >> newCommandFactory [
	^ PBApplication uniqueInstance newCommandSourceFactory
		addAllBindings: {#self -> self pythonInstance};
		yourself
]

{ #category : #accessing }
RlWordTableRow >> pythonInstance [
	^ pythonInstance
]

{ #category : #accessing }
RlWordTableRow >> pythonInstance: anObject [
	pythonInstance := anObject
]
