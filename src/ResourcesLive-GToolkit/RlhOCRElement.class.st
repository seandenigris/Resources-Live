Class {
	#name : #RlhOCRElement,
	#superclass : #BlElement,
	#instVars : [
		'selectionHandler',
		'client'
	],
	#category : #'ResourcesLive-GToolkit'
}

{ #category : #accessing }
RlhOCRElement >> addImage [
	| image |
	image := GtFileUtility
		imageElementFromFileReference: self client imageFile.
	self addChild: image
]

{ #category : #accessing }
RlhOCRElement >> addShortcuts [
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

{ #category : #accessing }
RlhOCRElement >> add_hOCR [
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

{ #category : #accessing }
RlhOCRElement >> applySelectedTextTo: desc [
	"Adaptation of MADescription>>#validate:, which is the main access point to validation i.e. all roads (e.g. mementos, forms) ultimately end up here. We're partially reimplementing instead of sending it ourselves because Magritte does not seem to really be set up to interact with element descriptions individually, but through their containers. In this case, the container supplies the proper validator for the domain object"

	[ self client magritteDescription validator
		on: (desc fromString: self selectedText)
		description: desc ]
			on: MAError
			do: [ Halt now. "Try to OCR again based on desc" ].
	self client write: (desc fromString: self selectedText) using: desc
]

{ #category : #accessing }
RlhOCRElement >> client [
	^ client
]

{ #category : #accessing }
RlhOCRElement >> client: anObject [
	client := anObject.
	self removeChildren.
	self size: client imageFile asRlResource extent.
	self addImage.
	self add_hOCR.
	self addShortcuts.
	^ self
]

{ #category : #accessing }
RlhOCRElement >> initialize [
	super initialize.
	
	"Get keyboard focus for shortcuts - now and on future clicks"
	self 
		when: BlClickEvent do: [ self requestFocus ];
		requestFocus.
]

{ #category : #accessing }
RlhOCRElement >> selectedText [
	^ (self selection first userData at: #node) string
]

{ #category : #accessing }
RlhOCRElement >> selection [
	^ self selectionHandler selected_hOCR
]

{ #category : #accessing }
RlhOCRElement >> selectionHandler [
	^ selectionHandler ifNil: [ selectionHandler := RlBlOcrSelectionHandler new ]
]
