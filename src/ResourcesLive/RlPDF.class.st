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

{ #category : #Bloc }
RlPDF >> asElement [
	| container image |
	container := BlElement new
		size: self imageFile asRlResource extent;
		yourself.
	image := GtFileUtility imageElementFromFileReference: self imageFile.
	container addChild: image.
	^ container.
]

{ #category : #Bloc }
RlPDF >> asElementHighlightingWords [
	| result |
	result := self asElement.
	self hocr words do: [ :w | result addChild: w asElement ].
	^ result
]

{ #category : #accessing }
RlPDF >> gtFigureFor: aView [
	<gtView>
	^ aView pannable
		title: 'Picture';
		priority: 1;
		stencil: [ 
			| imageElement |
			imageElement := GtFileUtility imageElementFromFileReference: self imageFile.
			imageElement forceLayout.
		imageElement 
			constraintsDo: [:c | c horizontal exact: imageElement width. c vertical exact: imageElement height ];
			yourself ]
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
	| outputRoot images |
	imageCache ifNotNil: [ ^ imageCache ].
	outputRoot := Tempfile withPrefix: 'rlpdf_'.
	images := RlPdfImages convert: self to: outputRoot.
	^ imageCache := images first
]

{ #category : #accessing }
RlPDF >> ocr [
	^ Smalltalk tools ocr ocr: self.
]
