Class {
	#name : #RlSQLite,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlSQLite class >> fileExtensions [
	^ #('sqlite')
]

{ #category : #'as yet unclassified' }
RlSQLite >> database [

	^ #SQLiteDatabase asClass file: self file
]
