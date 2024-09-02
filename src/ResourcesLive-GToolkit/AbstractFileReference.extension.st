Extension { #name : #AbstractFileReference }

{ #category : #'*ResourcesLive-GToolkit' }
AbstractFileReference >> previewGtViewFor: aView [
	"<gtView>"
	
	^ aView pannable
		title: 'Preview';
		priority: 25;
		stencil: [ self thumbnail ];
		yourself
]
