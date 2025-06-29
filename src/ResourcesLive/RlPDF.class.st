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

{ #category : #'file types' }
RlPDF class >> mimeTypes [
	^ { ZnMimeType applicationPdf }
]

{ #category : #'as yet unclassified' }
RlPDF >> asPlainText [

	^ self ocr
]

{ #category : #accessing }
RlPDF >> contentsGtViewFor: aView [
	<gtView>
	^ aView pannable
		title: 'Picture';
		priority: 25;
		stencil: [ self asElement ]
]

{ #category : #accessing }
RlPDF >> datesRecognized [
	
	| parseResult |
	parseResult := (Date pp2Parser sea ==> #second) plus parse: self ocr.
	^ parseResult isPetit2Failure
		ifFalse: [ parseResult asSet ]
		ifTrue: [ Set new ]
	
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

{ #category : #'as yet unclassified' }
RlPDF >> extractTextFields [

	^ PBApplication start newCommandStringFactory
		bindingAt: #file put: self file fullName;
		script: 'from pypdf import PdfReader

reader = PdfReader(file)';
		resultExpression: 'reader.get_form_text_fields()';
		sendAndWait.
]

{ #category : #accessing }
RlPDF >> gtHocrFor: aView [
	<gtView>
	^ aView forward
		title: 'hOCR';
		priority: 33;
		object: [ self hocr ];
		view: #gtLinesFor:
]

{ #category : #accessing }
RlPDF >> gtOCRFor: aView [
	<gtView>
	^ aView text
		title: 'OCR';
		priority: 44;
		text: [ self ocr ]
]

{ #category : #accessing }
RlPDF >> hocr [
	"See ${class:Hocr}$ comment"
	^ self cache
		at: #hocr
		ifPresent: [ :cacheResource | Hocr on: cacheResource contents ]
		ifAbsentPut: [ 
			| hocr tFile |
			hocr := Smalltalk tools ocr hocr: self.
			tFile := Tempfile named: self file base, '-hocr.xml'.
			tFile writeStreamDo: [ :str | str nextPutAll: hocr string ].
			tFile asRlResource ].
]

{ #category : #accessing }
RlPDF >> imageResource [
	| outputFile |
	self cache
		at: #image
		ifPresent: [ :cacheResource |
			cacheResource file exists
				ifTrue: [ ^ cacheResource ]
				ifFalse: [ self cache removeKey: #image ] ].
	
	outputFile := Tempfile withPrefix: 'rlpdf_' andSuffix: '.jpg'.
	SuImageMagick convertForOCR
		argumentAt: #inputFile put: self file;
		argumentAt: #outputFile put: outputFile;
		argumentAt: #pageRange put: (1 to: 1);
		run.
		
	^ self cache at: #image put: outputFile asRlResource
]

{ #category : #accessing }
RlPDF >> ocr [
	^ self cache
		at: #ocr
		ifAbsentPut: [ Smalltalk tools ocr ocr: self ]
]

{ #category : #accessing }
RlPDF >> wantsHOCR [
	^ false
]
