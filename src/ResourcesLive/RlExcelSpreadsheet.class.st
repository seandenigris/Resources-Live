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
			xls csv: csv.
			csv propertyAt: #ExcelFile put: xls ] ]"
]

{ #category : #accessing }
RlExcelSpreadsheet >> csv: anRlResource [
	"See getter comment"
	
	^ self 
		propertyAt: #csv
		putRemovingNil: anRlResource
]

{ #category : #accessing }
RlExcelSpreadsheet >> tabular [
	self flag: 'not sure if we will actually use this, so not loading Tabular by default'.
	^ #XLSXImporter asClass import: self
]
