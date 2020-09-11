"
I represent a PDF.
!Extracting Images
The use case supported is when each page is an image e.g. a scanned book. The ${method:RlPDF>>#tesseractInputFile}$ is tuned for OCR, while the ${method:RlPDF>>#vsImageFile}$ exports for viewing.
"
Class {
	#name : #RlPDF,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlPDF class >> fileExtensions [
	^ #('pdf')
]

{ #category : #accessing }
RlPDF >> gtFigureFor: aView [
	<gtView>
	^ aView explicit
		title: 'Picture';
		priority: 10;
		stencil: [ GtFileUtility imageElementFromFileReference: self vsImageFile ]
]
