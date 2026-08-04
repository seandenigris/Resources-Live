"
I am one node in the package/class/method presentation tree of an RlCodeLoadPlan.

Package nodes are structural. A class node is selectable only when the source proposes a class or trait definition change. Method and operation nodes carry their corresponding changes.
"
Class {
	#name : 'RlCodeChangeTreeNode',
	#superclass : 'Object',
	#instVars : [
		'kind',
		'name',
		'change',
		'children'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RlCodeChangeTreeNode class >> kind: aSymbol name: aString [
	^ self new
		kind: aSymbol;
		name: aString;
		yourself

]

{ #category : 'instance creation' }
RlCodeChangeTreeNode class >> treeFor: anRlCodeLoadPlan [
	| root |

	root := self
		kind: #root
		name: 'Changes'.

	(anRlCodeLoadPlan changes
		asSortedCollection: #sourceOrder ascending)
			do: [ :change |
				root
					addChange: change
					fromPlan: anRlCodeLoadPlan ].

	root sortRecursively.
	^ root

]

{ #category : 'building' }
RlCodeChangeTreeNode >> addChange: anRlCodeChange fromPlan: anRlCodeLoadPlan [
	| packageNode classNode leafKind |

	packageNode := self
		childKind: #package
		named:
			(anRlCodeLoadPlan
				packageNameForChange: anRlCodeChange).

	classNode := packageNode
		childKind: #class
		named: anRlCodeChange className.

	anRlCodeChange isClassDefinition ifTrue: [
		classNode change: anRlCodeChange.
		^ anRlCodeChange ].

	leafKind := anRlCodeChange isMethodChange
		ifTrue: [ #method ]
		ifFalse: [ #operation ].

	^ classNode children add:
		((self class
			kind: leafKind
			name: anRlCodeChange displayName)
				change: anRlCodeChange;
				yourself)

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> change [
	^ change

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> change: anRlCodeChange [
	change := anRlCodeChange

]

{ #category : 'building' }
RlCodeChangeTreeNode >> childKind: aKind named: aName [
	^ children
		detect: [ :child |
			child kind = aKind
				and: [ child name = aName ] ]
		ifNone: [
			children add:
				(self class
					kind: aKind
					name: aName) ]

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> children [
	^ children

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> displayName [
	self change ifNil: [ ^ self name ].

	^ self change treeDisplayName

]

{ #category : 'gt - views' }
RlCodeChangeTreeNode >> gtIcon [
	self kind = #package ifTrue: [
		^ Smalltalk ui icons iconNamed: #package ].
	self kind = #class ifTrue: [
		^ Smalltalk ui icons iconNamed: #class ].
	self kind = #method ifTrue: [
		^ Smalltalk ui icons iconNamed: #smallUpdate ].

	^ Smalltalk ui icons iconNamed: #smallDoIt

]

{ #category : 'gt - views' }
RlCodeChangeTreeNode >> gtIconElement [
	^ self gtIcon asElement
		constraintsDo: [ :constraints |
			constraints linear horizontal alignCenter ];
		yourself

]

{ #category : 'initialization' }
RlCodeChangeTreeNode >> initialize [
	super initialize.
	children := OrderedCollection new

]

{ #category : 'testing' }
RlCodeChangeTreeNode >> isSelectable [
	^ self change isNotNil

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> kind [
	^ kind

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> kind: aSymbol [
	kind := aSymbol

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> name [
	^ name

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> name: aString [
	name := aString

]

{ #category : 'accessing' }
RlCodeChangeTreeNode >> objectToSpawn [
	^ self change ifNil: [ self ]

]

{ #category : 'printing' }
RlCodeChangeTreeNode >> printOn: aStream [
	aStream nextPutAll: self displayName

]

{ #category : 'sorting' }
RlCodeChangeTreeNode >> sortRecursively [
	children := children asSortedCollection: #name ascending.
	children do: #sortRecursively

]
