Extension { #name : 'MailMessage' }

{ #category : '*ResourcesLive-GToolkit' }
MailMessage >> bodyTextGtViewFor: aView [
	<gtView>
	
	self asMarkdown ifNotNil: [ :md | 
		RlResource
			markdown: md 
			gtViewOn: aView 
			do: [ :renderedView |
				renderedView title: 'Body' translated ] ].
	
	^ aView textEditor
		title: 'Body' translated;
		priority: 20;
		text: [ self bodyTextFormatted ]
]
