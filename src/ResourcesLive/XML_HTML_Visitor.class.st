Class {
	#name : #'XML_HTML_Visitor',
	#superclass : #XMLNodeVisitor,
	#instVars : [
		'activeElement',
		'document'
	],
	#category : 'ResourcesLive-EPUB'
}

{ #category : #accessing }
XML_HTML_Visitor >> document [
	^ document ifNil: [ document := PRDocument new ]
]

{ #category : #accessing }
XML_HTML_Visitor >> visitDocument: aDocument [
	Transcript show: 'aDocument'; cr.
	"^ super visitDocument: aDocument"
	(aDocument xpath: '//body[1]/div/*') do: [ :e | e acceptNodeVisitor: self ].
	^ self document
]

{ #category : #accessing }
XML_HTML_Visitor >> visitElement: anElement [
	Transcript show: ('e: ', anElement name"printString first: 30"); cr.
	^ super visitElement: anElement
]

{ #category : #accessing }
XML_HTML_Visitor >> visitNode: aNode [
	Transcript show: ('n: ', aNode printString first: 30); cr.
	^ super visitNode: aNode
]

{ #category : #accessing }
XML_HTML_Visitor >> visitNodeWithElements: aNodeWithElements [
Transcript show: ('nwe: ', aNodeWithElements printString first: 30); cr.
	^ super visitNodeWithElements: aNodeWithElements
]
