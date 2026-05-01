Trait {
	#name : 'RlTPlayable',
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'accessing' }
RlTPlayable >> defaultDriver [
	^ self explicitRequirement
]

{ #category : 'accessing' }
RlTPlayable >> newPlayer [
	| result |
	result := self playerClass on: self.
	self playerDriver ifNotNil: [ :driver | result driver: driver ].
	^ result
]

{ #category : 'accessing' }
RlTPlayable >> playerClass [
	^ RlMediaPlayer
]

{ #category : 'accessing' }
RlTPlayable >> playerDriver [

	^ self
		propertyAt: #playerDriver
		ifAbsent: [ self defaultDriver ]
]

{ #category : 'accessing' }
RlTPlayable >> playerDriver: anObject [
	self propertyAt: #playerDriver putRemovingNil: anObject
]
