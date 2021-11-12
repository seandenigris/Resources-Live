Extension { #name : #LeContent }

{ #category : #'*ResourcesLive-GToolkit' }
LeContent >> rlClipHTMLFragment [

	| file |
	file := FileSystem memory / 'some.html'.
	file writeStreamDo: [ :s | s nextPutAll: self asHTMLFragment ].
	file asRlResource clip.
]
