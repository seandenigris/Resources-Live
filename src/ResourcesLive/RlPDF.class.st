"
I represent a PDF.

# Archiving
PDF/A-2b is [apparently](https://www.pdftron.com/blog/pdfa-format/how-to-pick-right-version-of-pdfa/) the sweet spot between reliable retrieval and ease of creation.

# Extracting Images
The use case supported is when each page is an image e.g. a scanned book. The {{gtMethod:RlPDF>>#tesseractInputFile}} is tuned for OCR, while the {{gtMethod:RlPDF>>#vsImageFile}} exports for viewing.

"
Class {
	#name : #RlPDF,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlPDF class >> exampleReceipt [
	<gtExample>
	^ self on: self exampleSupportFolder / 'Receipt_cash.pdf'
]

{ #category : #'file types' }
RlPDF class >> fileExtensions [
	^ #('pdf')
]

{ #category : #accessing }
RlPDF >> datesRecognized [
	
	^ ((PP2DateParser new sea ==> #second) plus parse: self ocr) asSet
	
	"Previously tried several other algorithms:
	
	1. hocr word analysis, but seemed slow and missed dates across word boundaries e.g. 'March 12, 2022':
	```smalltalk
	self hocr words 
		inject: Set new 
		into: [ :set :word | 
			[ set add: word string asDate ] 
				onErrorDo: [ ].
			set ]
	```
	
	2. Python - didn't seem very accurate e.g. failed to find '...March 12, 2022...':
	```python
	import datefinder
	matches = list(datefinder.find_dates(text))

	def to_timestamp(dt):
		import datetime
		return int(dt.replace(tzinfo=datetime.timezone.utc).timestamp())
	  
	list(map(to_timestamp, matches))
	```"
]

{ #category : #accessing }
RlPDF >> gtFigureFor: aView [
	<gtView>
	^ aView pannable
		title: 'Picture';
		priority: 1;
		stencil: [ self asElement ]
]

{ #category : #accessing }
RlPDF >> gtHocrFor: aView [
	<gtView>
	^ aView forward
		title: 'hOCR';
		priority: 2;
		object: [ self hocr ];
		view: #gtLinesFor:
]

{ #category : #accessing }
RlPDF >> gtOCRFor: aView [
	<gtView>
	^ aView text
		title: 'OCR';
		priority: 3;
		text: [ self ocr ]
]

{ #category : #accessing }
RlPDF >> hocr [
	"See ${class:Hocr}$ comment"
	^ self
		propertyAt: #hocrCache
		ifPresent: [ :cacheResource | Hocr on: cacheResource contents ]
		ifAbsent: [ 
			| hocr tFile cacheResource |
			hocr := Smalltalk tools ocr hocr: self.
			tFile := Tempfile named: self file base, '-hocr.xml'.
			tFile writeStreamDo: [ :str | str nextPutAll: hocr string ].
			cacheResource := self library import: tFile reference.			
			self propertyAt: #hocrCache put: cacheResource.
			hocr ].
		
	
]

{ #category : #accessing }
RlPDF >> imageFile [
	| outputFile |
	self propertyAt: #imageCache ifPresent: [ :ic | ^ ic ].
	
	outputFile := Tempfile withPrefix: 'rlpdf_' andSuffix: '.jpg'.
	SuImageMagick convertForOCR
		argumentAt: #inputFile put: self file;
		argumentAt: #outputFile put: outputFile;
		argumentAt: #pageRange put: (1 to: 1);
		run.
		
	^ self propertyAt: #imageCache put: outputFile
]

{ #category : #accessing }
RlPDF >> ocr [
	^ self
		propertyAt: #ocrCache
		ifAbsentPut: [ Smalltalk tools ocr ocr: self ]
]

{ #category : #accessing }
RlPDF >> wantsHOCR [
	^ false
]
