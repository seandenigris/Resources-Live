Class {
	#name : #RlImageMagick,
	#superclass : #Object,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlImageMagick class >> binary [
	^ 'convert'
]

{ #category : #converting }
RlImageMagick >> commandTemplate [

	^ 'convert -density 300 "{input}" -depth 8 -strip -background white -alpha off "{output}"'.
]

{ #category : #converting }
RlImageMagick >> convert: inputFile to: outputFile [

	| commandTemplate command p |
	commandTemplate := 'convert -density 300 "{input}" -depth 8 -strip -background white -alpha off "{output}"'.
	command := commandTemplate
		format:
			{(#input -> inputFile fullName).
			(#output -> outputFile)} asDictionary.
	p := PipeableOSProcess waitForCommand: command.
	self assert: p succeeded
]
