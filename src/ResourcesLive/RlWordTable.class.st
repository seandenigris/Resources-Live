Class {
	#name : #RlWordTable,
	#superclass : #Object,
	#instVars : [
		'pythonInstance'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlWordTable class >> fromProxy: aPBProxy [

	^ self new
		pythonInstance: aPBProxy;
		yourself
]

{ #category : #accessing }
RlWordTable >> addRow [

	| row |
	row := self newCommandFactory
	    sourceWithResult: 'self.add_row()';
	    sendAndWait.
	    
	^ RlWordTableRow fromProxy: row
]

{ #category : #accessing }
RlWordTable >> atRow: rowIndex andColumn: columnIndex put: aString [

	self newCommandFactory
		bindingAt: #rowIndex put: rowIndex - 1;
		bindingAt: #columnIndex put: columnIndex - 1;
		bindingAt: #aString put: aString;
		source: 'self.cell(rowIndex, columnIndex).text = aString';
		sendAndWait.
]

{ #category : #accessing }
RlWordTable >> newCommandFactory [
	^ PBApplication uniqueInstance newCommandSourceFactory
		addAllBindings: {#self -> self pythonInstance};
		yourself
]

{ #category : #accessing }
RlWordTable >> pythonInstance [
	^ pythonInstance
]

{ #category : #accessing }
RlWordTable >> pythonInstance: anObject [
	pythonInstance := anObject
]
