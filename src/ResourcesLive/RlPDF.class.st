"
I represent a PDF.
!Extracting Images
The use case supported is when each page is an image e.g. a scanned book. The ${method:RlPDF>>#tesseractInputFile}$ is tuned for OCR, while the ${method:RlPDF>>#vsImageFile}$ exports for viewing.
"
Class {
	#name : #RlPDF,
	#superclass : #RlResource,
	#instVars : [
		'imageCache'
	],
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

	^ Smalltalk tools ocr hocr: self.
]

{ #category : #accessing }
RlPDF >> imageCache [
	^ imageCache
]

{ #category : #accessing }
RlPDF >> imageFile [
	| outputFile images |
	imageCache ifNotNil: [ ^ imageCache ].
	outputFile := Tempfile withPrefix: 'rlpdf_' andSuffix: '.jpg'.
	SuImageMagick convertForOCR
		argumentAt: #inputFile put: self file;
		argumentAt: #outputFile put: outputFile;
		argumentAt: #pageRange put: (1 to: 1);
		run.
	^ imageCache := outputFile
]

{ #category : #accessing }
RlPDF >> ocr [
	^ Smalltalk tools ocr ocr: self.
]

{ #category : #accessing }
RlPDF >> wants_hOCR [
	^ true
]
