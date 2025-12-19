"
I am a wrapper for `pdfimages`, an open-source command-line utility for extracting images from PDF files. I extract the raw images, so images e.g. that were rotated by the PDF will be extracted in their original orientation. I handle only raster images, not vector images [(per the imagemagick forums](https://imagemagick.org/discourse-server/viewtopic.php?p=131715&sid=7d4ead65c1b80614d9afb52ed274059f#p131715)). I am utility from the [Poplar](https://poppler.freedesktop.org) PDF Rendering library. For more info, see [my wikipedia page](https://en.wikipedia.org/wiki/Pdfimages).
# Installation
On Mac, can be installed via Homebrew like so:
```language=shell
brew install poppler
```

"
Class {
	#name : 'RlPdfImages',
	#superclass : 'Object',
	#instVars : [
		'inputFile',
		'outputRoot'
	],
	#category : 'ResourcesLive-Utilities',
	#package : 'ResourcesLive',
	#tag : 'Utilities'
}

{ #category : 'accessing' }
RlPdfImages class >> binary [
	^ '/usr/local/bin/pdfimages'
]

{ #category : 'convenience' }
RlPdfImages class >> convert: inputFile to: outputRoot [

	^ self new
		input: inputFile;
		outputRoot: outputRoot;
		run;
		images
]

{ #category : 'accessing' }
RlPdfImages class >> example [
	<gtExample>
	| inputJpeg tempFolder outputRoot images |
	tempFolder := (FileLocator temp / DateAndTime totalSeconds asString) ensureCreateDirectory.
	inputJpeg := BaselineOfResourcesLive exampleSupportFolder / 'jpg.pdf'.
	outputRoot := tempFolder / 'out'.
		
	[ 
		images := RlPdfImages convert: inputJpeg to: outputRoot.
		self assert: images size = 1.
		self assert: images first exists.
	] ensure: [ images first delete ].
]

{ #category : 'converting' }
RlPdfImages >> commandString [

	^ self commandTemplate
		format:
			{(#input -> self inputFile asFileReference fullName).
			(#output -> self outputRoot asFileReference fullName)} asDictionary
]

{ #category : 'converting' }
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

	^ self class binary, ' -j -p "{input}" "{output}"'
]

{ #category : 'views' }
RlPdfImages >> gtCLIViewFor: aView [
	<gtView>
	^ aView text 
		title: 'CLI';
		text: self commandString
		
]

{ #category : 'convenience' }
RlPdfImages >> images [
	^ self outputRoot parent filesMatching: self outputRoot basename, '*'
	"Note: Image basenames are of the form `{root}-{page#}-{image#}`, where:
		- #'s are padded with zeroes to three digits
		- page #'s start at 1
		- image #'s start at 0
	For example, for image 0 from page 1, if returned as a JPEG, would end in 001-000.jpg"
]

{ #category : 'accessing' }
RlPdfImages >> input: convertibleToFile [
	"convertibleToFile - should respond to #asFileReference"
	inputFile := convertibleToFile
]

{ #category : 'accessing' }
RlPdfImages >> inputFile [
	^ inputFile
]

{ #category : 'accessing' }
RlPdfImages >> outputRoot [
	^ outputRoot
]

{ #category : 'accessing' }
RlPdfImages >> outputRoot: convertibleToFile [
	"Where to save. A suffix will be applied by the library.
	convertibleToFile - should respond to #asFileReference"
	outputRoot := convertibleToFile
]

{ #category : 'converting' }
RlPdfImages >> run [
	self outputRoot asFileReference parent ensureCreateDirectory. "pdfimages will fail if it doesn't exist"
	self shell runWaitAndAssert: self commandString
]

{ #category : 'converting' }
RlPdfImages >> shell [
	"Hook to find all these roll-your-own shell things to replace with Pharo-Shell"
	^ LibC
]
