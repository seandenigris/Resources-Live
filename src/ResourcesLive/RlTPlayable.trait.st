Trait {
	#name : 'RlTPlayable',
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'accessing' }
RlTPlayable >> defaultDriverClass [
	^ self explicitRequirement
]

{ #category : 'accessing' }
RlTPlayable >> newPlayer [
	| result |
	result := self playerClass on: self.
	self playerDriverClass ifNotNil: [ :driverClass | result driver: driverClass new ].
	^ result
]

{ #category : 'accessing' }
RlTPlayable >> playerClass [
	^ RlMediaPlayer
]

{ #category : 'accessing' }
RlTPlayable >> playerDriverClass [

	^ self
		propertyAt: #playerDriverClass		
		ifAbsent: [ self defaultDriverClass ]
]

{ #category : 'accessing' }
RlTPlayable >> playerDriverClass: anObject [
	self propertyAt: #playerDriverClass putRemovingNil: anObject
]
