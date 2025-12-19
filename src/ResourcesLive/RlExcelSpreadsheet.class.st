Class {
	#name : 'RlExcelSpreadsheet',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlExcelSpreadsheet class >> fileExtensions [
	^ #('xls' 'xlsx')
]

{ #category : 'accessing' }
RlExcelSpreadsheet >> csv [
	self flag: 'must create manually for now. There was a SO thread about it formerly being possible via python and not much other info'.
	
	^ self 
		propertyAt: #csv
		ifAbsent: [ nil ].
		
	"Possibly relevant to future auto-find feature: 
	xls file parent parent / 'RlCSV' / xls file base, 'csv'.
spreadsheets do: [ :xls | 
	(xls library tail last: 3)
		detect: [ :cand | cand file base = xls file base ]
		ifFound: [ :csv |
			xls csv: csv ] ]"
]

{ #category : 'accessing' }
RlExcelSpreadsheet >> csv: anRlResource [
	"See getter comment"
	
	anRlResource ifNotNil: [ 
		anRlResource 
			propertyAt: #ExcelFile 
			put: self ].
	
	^ self 
		propertyAt: #csv
		putRemovingNil: anRlResource
]

{ #category : 'accessing' }
RlExcelSpreadsheet >> tabular [
	self flag: 'not sure if we will actually use this, so not loading Tabular by default'.
	^ #XLSXImporter asClass import: self
]

{ #category : 'accessing' }
RlExcelSpreadsheet >> tabularCSV [
	
	file := Tempfile withExtension: 'csv'.
	file writeStreamDo: [ :str |
		| writer |
		writer := NeoCSVWriter on: str.
		self tabular worksheets first rowsDo: [ :rowArray |
			writer nextPut: rowArray ] ].
	^ file
]
