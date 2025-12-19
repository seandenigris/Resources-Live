"
Editing powered by [python-docx](https://python-docx.readthedocs.io/en/latest/)
"
Class {
	#name : 'RlWordDocX',
	#superclass : 'RlWordDoc',
	#instVars : [
		'pythonInstance'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'file types' }
RlWordDocX class >> fileExtensions [
	^ #('docx')
]

{ #category : 'example' }
RlWordDocX class >> modificationExample [
	<gtExample>
	
	| docx table |
	docx := self new
		beLandscape;
		addHeading: 'Heading';
		addParagraph: 'Paragraph';
		yourself.
	
	table := docx addTableWithRows: 1 andColumns: 2.
	table 
		atRow: 1 andColumn: 1 put: 'col 1';
		atRow: 1 andColumn: 2 put: 'col 2'.
		
	table addRow
		at: 1 put: 'row 2 col 1';
		at: 2 put: 'row 2 col 2'.
	
	^ docx
		addPageBreak;
		addParagraph: 'Paragraph on page 2';
		saveTo: (Tempfile withSuffix: 'RlWord.docx');
		yourself.
]

{ #category : 'accessing' }
RlWordDocX class >> typeName [

	^ 'DocX'
]

{ #category : 'accessing' }
RlWordDocX >> addHeading: aString [

	^ self newCommandFactory
		addAllBindings: { 
			 #aString -> aString } asDictionary;
		sourceWithResult: 'self.add_heading(aString)';
		sendAndWait
]

{ #category : 'accessing' }
RlWordDocX >> addPageBreak [

	^ self newCommandFactory
	    sourceWithResult: 'self.add_page_break()';
	    sendAndWait.
]

{ #category : 'accessing' }
RlWordDocX >> addParagraph: aString [

	^ self newCommandFactory
	    addAllBindings: { 
	        #aString -> aString } asDictionary;
	    sourceWithResult: 'self.add_paragraph(aString)';
	    sendAndWait.
]

{ #category : 'accessing' }
RlWordDocX >> addTableWithRows: rowCount andColumns: columnCount [

	| table |
	table := self newCommandFactory
		addAllBindings: { 
			#rowCount -> rowCount.
			#columnCount -> columnCount };
		sourceWithResult: 'self.add_table(rowCount,columnCount)';
		sendAndWait.
		
	^ RlWordTable fromProxy: table
]

{ #category : 'accessing' }
RlWordDocX >> beLandscape [

	^ self newCommandFactory
	    source: 'from docx.enum.section import WD_ORIENT

self.sections[-1].orientation = WD_ORIENT.LANDSCAPE';
	    sendAndWait.
]

{ #category : 'accessing' }
RlWordDocX >> newCommandFactory [
	^ PBApplication uniqueInstance newCommandSourceFactory
		addAllBindings: {#self -> self pythonInstance};
		yourself
]

{ #category : 'private' }
RlWordDocX >> pythonInstance [
	| argument command |
	pythonInstance ifNotNil: [ ^ pythonInstance ].
	
	command := PBApplication uniqueInstance newCommandStringFactory
	    script: 'from docx import Document';
	    resultExpression: 'Document()'.
	
	argument := file
		ifNotNil: [ 
			command 
				addAllBindings: { 
					#aString -> file fullName } asDictionary;
				resultExpression: 'Document(aString)' ]
		ifNil: [ command resultExpression: 'Document()' ].
	
	^ pythonInstance := command sendAndWait.
	    
	"Reference: https://python-docx.readthedocs.io/en/latest/api/document.html#document-constructor"
]

{ #category : 'accessing' }
RlWordDocX >> saveTo: aFileReference [

	self newCommandFactory
		addAllBindings: { #aString -> aFileReference fullName } asDictionary;
		sourceWithResult: 'self.save(aString)';
		sendAndWait.
		
	self file: aFileReference
]
