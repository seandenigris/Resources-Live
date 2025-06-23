Class {
	#name : #RlSVG,
	#superclass : #RlPicture,
	#category : #'ResourcesLive-Core'
}

{ #category : #'file types' }
RlSVG class >> fileExtensions [
	^ #('svg')
]

{ #category : #accessing }
RlSVG class >> mimeTypes [
	^ { ZnMimeType imageSvg }
]

{ #category : #'as yet unclassified' }
RlSVG >> as: anRlResourceClass [

	| target |
	target := Tempfile named: self file base, '.', anRlResourceClass fileExtensions first.
	SuRsvgConvert
		from: self file
		to: target.
		
	^ target asRlResource
]

{ #category : #'as yet unclassified' }
RlSVG >> asPNG [

	| target |
	target := Tempfile named: self file base, '.png'.
	SuRsvgConvert
		from: self file
		to: target.
		
	^ target asRlResource
]
