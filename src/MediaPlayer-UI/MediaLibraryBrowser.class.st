Class {
	#name : #MediaLibraryBrowser,
	#superclass : #Object,
	#category : #'MediaPlayer-UI'
}

{ #category : #'as yet unclassified' }
MediaLibraryBrowser class >> browseMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Browse Media')
		action: [ self open ].
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser class >> open [

	^ self new open.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> addInspectCommandTo: presentation [

	presentation	act: [ :list | list selection inspect ]
		icon: GLMUIThemeExtraIcons glamorousInspect
		on: $i 
		entitled: 'Inspect clip'.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> addOpenCommandTo: presentation [

	presentation act: [ :list | list selection open ]
		icon: GLMUIThemeExtraIcons glamorousOpen
		on: $o 
		entitled: 'Open clip as morph'.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> addPlayCommandTo: presentation [

	presentation act: [ :list | self play: list selection ]
		icon: GLMUIThemeExtraIcons glamorousPlay
		on: $p 
		entitled: 'Play clip'.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> glamorous [

	| browser |
	browser := GLMTabulator new.
	browser with: [ :t |
		t
			row: #videos;
			row: #clips.
		t transmit to: #videos; andShow: [ :a | self showVideosIn: a ].
		t transmit from: #videos; to: #clips; andShow: [ :a |
			a list
				title: 'Clips';
				display: #clips;
				format: [ :clip | clip subtitle isEmpty
						ifTrue: [ clip asString ]
						ifFalse: [ clip subtitle ] ].
			self addPlayCommandTo: a.
			self addInspectCommandTo: a.
			self addOpenCommandTo: a ] ].
	^ browser.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> importVideo [

	ImportVideoMorph open.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> open [

	self glamorous openOn: MediaLibrary default.
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> play: aPlayable [

	aPlayable play.
	(MediaPlayerMorph on: aPlayable) openInWorld
]

{ #category : #'as yet unclassified' }
MediaLibraryBrowser >> showVideosIn: presentation [

	presentation list
		title: 'Videos';
		display: #videos;
"		format: #description;"
		act: [ :list | self play: list selection ]
					icon: GLMUIThemeExtraIcons glamorousPlay
					on: $p 
					entitled: 'Play video';
				act: [ :list | list selection inspect ]
					icon: GLMUIThemeExtraIcons glamorousInspect
					on: $i 
					entitled: 'Inspect video';
				act: [ :list |
							self importVideo.
							list update ]
					icon: GLMUIThemeExtraIcons glamorousAdd
					on: $a
					entitled: 'Import video'
]
