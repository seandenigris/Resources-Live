Class {
	#name : #RlGhostscript,
	#superclass : #Object,
	#category : 'ResourcesLive-Core'
}

{ #category : #accessing }
RlGhostscript class >> binary [
	^ 'gs'
]

{ #category : #converting }
RlGhostscript >> commandTemplate [

	^ 'gs -o "{output}.png" -dSAFER -dQUIET -sDEVICE=pnggray -dINTERPOLATE -dNumRenderingThreads=8 -r300 -c 30000000 setvmthreshold -f "{input}"'.
	
	"GS option explanations:
		-dSAFER \ # prevent unwanted file writing
		-dQUIET \ # suppress some console output
		-sDEVICE=png16m \ # Save in 24 bit color, -sDEVICE=pnggray -dTextAlphaBits=4 worked equally well; tiffg4 (from [GH](https://gist.github.com/henrik/1967035)) *is for B&W* and was awful on grayscale input, tiff12nc caused an error apparently because it's not compressed
		-dINTERPOLATE \ # Designed to improve the quality of images that have been upscaled from a smaller size
		-dNumRenderingThreads=8 \ #Gs recommends setting this option to the maximum number of available cores
		-r300 \ # Tesseract default of 72dpi is much too low for good results; 300dpi seems to be the consensus
		-c 30000000 setvmthreshold -f \ # Boost performance with 30MB extra RAM for complex PDFs"
]

{ #category : #converting }
RlGhostscript >> convert: inputFile to: outputFile [

	| commandTemplate command p |
	commandTemplate := 'gs -o "{output}" -dSAFER -dQUIET -sDEVICE=png16m -dINTERPOLATE -dNumRenderingThreads=8 -r300 -c 30000000 setvmthreshold -f "{input}"'.
	command := commandTemplate
		format:
			{(#input -> inputFile fullName).
			(#output -> outputFile fullName)} asDictionary.
	p := PipeableOSProcess waitForCommand: command.
	self assert: p succeeded
	
	"GS option explanations:
		-dSAFER \ # prevent unwanted file writing
		-dQUIET \ # suppress some console output
		-sDEVICE=png16m \ # Save in 24 bit color, -sDEVICE=pnggray -dTextAlphaBits=4 worked equally well; tiffg4 (from [GH](https://gist.github.com/henrik/1967035)) *is for B&W* and was awful on grayscale input, tiff12nc caused an error apparently because it's not compressed
		-dINTERPOLATE \ # Designed to improve the quality of images that have been upscaled from a smaller size
		-dNumRenderingThreads=8 \ #Gs recommends setting this option to the maximum number of available cores
		-r300 \ # Tesseract default of 72dpi is much too low for good results; 300dpi seems to be the consensus
		-c 30000000 setvmthreshold -f \ # Boost performance with 30MB extra RAM for complex PDFs"
]
