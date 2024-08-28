Class {
	#name : #RlCache,
	#superclass : #Object,
	#traits : 'MATPropertyOwner',
	#classTraits : 'MATPropertyOwner classTrait',
	#category : #'ResourcesLive-Core'
}

{ #category : #caching }
RlCache >> at: aSymbol [
	^ self 
		propertyAt: aSymbol
		ifAbsent: [ nil ]
]

{ #category : #caching }
RlCache >> at: aSymbol ifAbsentPut: absentBlock [ 

	^ self 
		propertyAt: aSymbol
		ifAbsentPut: absentBlock.
]

{ #category : #caching }
RlCache >> at: aSymbol ifPresent: presentBlock [

	^ self 
		propertyAt: aSymbol 
		ifPresent: presentBlock
]

{ #category : #caching }
RlCache >> at: aSymbol ifPresent: presentBlock ifAbsentPut: absentBlock [ 

	| cachedValue |
	cachedValue := self 
		at: aSymbol 
		ifAbsentPut: absentBlock.
		
	^ presentBlock value: cachedValue
]

{ #category : #caching }
RlCache >> at: aSymbol put: anObject [
	^ self propertyAt: aSymbol put: anObject
]

{ #category : #fuel }
RlCache >> fuelAccept: aGeneralMapper [
	"Never serialize"
	
    ^ aGeneralMapper visitSubstitution: self by: nil
]

{ #category : #'as yet unclassified' }
RlCache >> removeKey: aSymbol [

	^ self properties removeKey: #image
]

{ #category : #accessing }
RlCache >> reset [

	self properties removeAll
]

{ #category : #accessing }
RlCache >> resourceLibrary [
	^ self propertyAt: #resourceLibrary ifAbsent: [ RlResourceLibrary uniqueInstance ]
]

{ #category : #'instance creation' }
RlCache >> saveResourceableAt: aSymbol [

	| value |
	value := self at: aSymbol.
	self resourceLibrary import: value asRlResource
]
