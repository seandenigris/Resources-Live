"
A utility from the *Poplar>https://poppler.freedesktop.org* PDF Rendering library
!Installation
On Mac, can be installed via Homebrew like so:
[[[language=shell
brew install poppler
]]]

"
Class {
	#name : #RlPdfImages,
	#superclass : #Object,
	#instVars : [
		'inputFile',
		'outputRoot'
	],
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlPdfImages class >> binary [
	^ '/usr/local/bin/pdfimages'
]

{ #category : #convenience }
RlPdfImages class >> convert: inputFile to: outputFolder [

	^ self new
		inputFile: inputFile;
		outputRoot: outputFolder;
		run
]

{ #category : #accessing }
RlPdfImages class >> example [
	<gtExample>
	| inputJpeg tempFolder outputRoot command outputFile |
	tempFolder := (FileLocator temp / DateAndTime totalSeconds asString) ensureCreateDirectory.
	inputJpeg := FileLocator localDirectory / 'iceberg' / 'seandenigris' / 'Resources-Live'/ 'example support' / 'jpg.pdf'.
	outputRoot := tempFolder / 'out'.
	outputFile := outputRoot parent / (outputRoot basename, '-000.jpg').
	
	command := RlPdfImages new
		inputFile: inputJpeg;
		outputRoot:outputRoot;
		yourself.
		
	[ 
		command run.
		self assert: outputFile exists.
	] ensure: [ outputFile delete ].
]

{ #category : #converting }
RlPdfImages >> commandString [

	^ self commandTemplate
		format:
			{(#input -> self inputFile fullName).
			(#output -> self outputRoot fullName)} asDictionary
]

{ #category : #converting }
RlPdfImages >> commandTemplate [
	"
	Output format options:
		-png           : change the default output format to PNG
		-tiff          : change the default output format to TIFF
		-j             : write JPEG images as JPEG files
		-jp2           : write JPEG2000 images as JP2 files
		-jbig2         : write JBIG2 images as JBIG2 files
		-ccitt         : write CCITT images as CCITT files
		-all           : equivalent to -png -tiff -j -jp2 -jbig2 -ccitt"

	^ self class binary, ' -j "{input}" "{output}"'
]

{ #category : #views }
RlPdfImages >> gtCLIViewFor: aView [
	<gtView>
	^ aView text 
		title: 'CLI';
		text: self commandString
		
]

{ #category : #accessing }
RlPdfImages >> inputFile [
	^ inputFile
]

{ #category : #accessing }
RlPdfImages >> inputFile: anObject [
	inputFile := anObject
]

{ #category : #accessing }
RlPdfImages >> outputRoot [
	^ outputRoot
]

{ #category : #accessing }
RlPdfImages >> outputRoot: aFileReference [
	"Where to save. A suffix will be applied by the library."
	outputRoot := aFileReference
]

{ #category : #converting }
RlPdfImages >> run [

	| command returnValue |
	self shell runWaitAndAssert: self commandString
]

{ #category : #converting }
RlPdfImages >> shell [
	"Hook to find all these roll-your-own shell things to replace with Pharo-Shell"
	^ LibC
]
