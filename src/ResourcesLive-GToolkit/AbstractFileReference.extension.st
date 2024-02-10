Extension { #name : #AbstractFileReference }

{ #category : #'*ResourcesLive-GToolkit' }
AbstractFileReference >> gtContentsFor: aView [
	<gtView>
	| eventLoop |
	self isFile ifFalse: [ ^ aView empty ].
	[ self readStreamDo: [ :s | s next: 1000 ] ]
		on: ZnInvalidUTF8
		do: [ ^ aView empty ].

	eventLoop := self watcher startLoop.

	^ aView explicit
		title: 'Contents' translated;
		priority: 50;
		updateWhen: GtFileWatcherModificationAnnouncement in: eventLoop announcer;
		stencil: [ self gtEditorView ]
]

{ #category : #'*ResourcesLive-GToolkit' }
AbstractFileReference >> previewGtViewFor: aView [
	"<gtView>"
	
	^ aView pannable
		title: 'Preview';
		priority: 25;
		stencil: [ self thumbnail ];
		yourself
]
