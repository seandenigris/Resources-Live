Class {
	#name : 'RlHOCRElement',
	#superclass : 'BlElement',
	#instVars : [
		'selectionHandler',
		'client'
	],
	#category : 'ResourcesLive-GToolkit'
}

{ #category : 'accessing' }
RlHOCRElement >> addImage [
	| image |
	image := GtFileUtility
		imageElementFromFileReference: self client imageFile.
	self addChild: image
]

{ #category : 'accessing' }
RlHOCRElement >> addShortcuts [
	| shortcutFields |
	shortcutFields := self client magritteDescription children select: [ :e | e hasProperty: #shortcut ].
	shortcutFields do: [ :desc | 
		| keySelector key keyCombo shortcut |
		keySelector := desc propertyAt: #shortcut.
		key := BlKeyboardKey perform: keySelector.
		keyCombo := BlKeyCombination builder
			key: key;
			build.
		shortcut := BlShortcut new
			combination: keyCombo;
			action: [ :anEvent :aShortcut | self applySelectedTextTo: desc ];
			yourself.
		self addShortcut: shortcut ]
]

{ #category : 'accessing' }
RlHOCRElement >> add_hOCR [
	self client hocr words do: [ :w | 
		| wordElement |
		wordElement := w asElement
			border: BlBorder empty;
			addEventHandlerOn: BlElementSelectionAcquiredEvent
				do: [ :anEvent | 
				anEvent target owner
					border:
						(BlBorder builder
							width: 2;
							paint: Color blue;
							build) ];
			addEventHandlerOn: BlElementSelectionLostEvent
				do: [ :anEvent | anEvent target owner border: BlBorder empty ];
			yourself.
			self addChild: wordElement ].
	self addEventHandler: self selectionHandler
]

{ #category : 'accessing' }
RlHOCRElement >> applySelectedTextTo: desc [
	"Adaptation of MADescription>>#validate:, which is the main access point to validation i.e. all roads (e.g. mementos, forms) ultimately end up here. We're partially reimplementing instead of sending it ourselves because Magritte does not seem to really be set up to interact with element descriptions individually, but through their containers. In this case, the container supplies the proper validator for the domain object"

	| value |
	[ 
		value := desc fromString: self selectedText.
		self client magritteDescription validator on: value description: desc
	]
		on: MAError
		do: [ 
			| inputFile ocr |
			inputFile := Tempfile withSuffix: self client tesseractInputFile extension.
			SuImageMagick
				crop: self client tesseractInputFile
				to: (self selection first userData at: #node) boundingBox
				as: inputFile.
			ocr := Smalltalk tools ocr new
				isHocr: false;
				segmentationMode: TeSegmentationMode word;
				client: inputFile.
			desc propertyAt: #whitelist ifPresent: [ :wl | ocr characterWhitelist: wl ].
			value := desc fromString: ocr run trim ].
	Halt now.
	self client write: value using: desc
]

{ #category : 'accessing' }
RlHOCRElement >> client [
	^ client
]

{ #category : 'accessing' }
RlHOCRElement >> client: anObject [
	client := anObject.
	self removeChildren.
	self size: client imageFile asRlResource extent.
	self addImage.
	self client wants_hOCR ifTrue: [ self add_hOCR ]. "If the client doesn't need OCR, don't waste time on it [1]"
	self addShortcuts.
	^ self
	
	"
	1. The motivation was a credit card statement for which the OCR was useless - containing hundreds of tiny 'words' that were not actual words - and did nothing but slow the system down significantly"
]

{ #category : 'accessing' }
RlHOCRElement >> initialize [
	super initialize.
	
	"Get keyboard focus for shortcuts - now and on future clicks"
	self 
		when: BlClickEvent do: [ self requestFocus ];
		requestFocus.
]

{ #category : 'accessing' }
RlHOCRElement >> selectedText [
	^ (self selection first userData at: #node) string
]

{ #category : 'accessing' }
RlHOCRElement >> selection [
	^ self selectionHandler selected_hOCR
]

{ #category : 'accessing' }
RlHOCRElement >> selectionHandler [
	^ selectionHandler ifNil: [ selectionHandler := RlBlOcrSelectionHandler new ]
]
