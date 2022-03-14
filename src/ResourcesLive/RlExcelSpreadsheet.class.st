Class {
	#name : #RlExcelSpreadsheet,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlExcelSpreadsheet class >> fileExtensions [
	^ #('xlsx')
]

{ #category : #accessing }
RlExcelSpreadsheet >> csv [
	self flag: 'must create manually for now'.
	^ RlResource on: self file withoutExtension, 'csv'.
]

{ #category : #accessing }
RlExcelSpreadsheet >> tabular [
	self flag: 'not sure if we will actually use this, so not loading Tabular by default'.
	^ #XLSXImporter asClass import: self
]
