"
!Installation
On Mac, you can install via Homebrew like this:
[[[language=shell
brew install imagemagick
]]]

"
Class {
	#name : #RlImageMagick,
	#superclass : #RlPdfToImageConverter,
	#category : #'ResourcesLive-Utilities'
}

{ #category : #accessing }
RlImageMagick class >> binary [
	^ 'convert'
]

{ #category : #converting }
RlImageMagick >> commandTemplate [

	^ self class binary, ' -density 300 "{input}" -depth 8 -strip -background white -alpha off "{output}"'.
]
