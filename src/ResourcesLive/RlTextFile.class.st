Class {
	#name : 'RlTextFile',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlTextFile class >> fileExtensions [
	^ #('txt')
]

{ #category : 'accessing' }
RlTextFile >> diff: rhs [

	^ PeCharacterDiff 
		comparing: self contents
		to: rhs contents
]
