Extension { #name : #MailMessage }

{ #category : #'*ResourcesLive-GToolkit' }
MailMessage >> bodyTextGtViewFor: aView [
	<gtView>
	
	self asMarkdown ifNotNil: [ :md | 
		| snip viewModel aSnippetElement |
		snip := LeTextSnippet string: md.
		viewModel := snip asSnippetViewModel.
		aSnippetElement := viewModel snippetView asElement.
		aSnippetElement snippetViewModel: viewModel.
		^ aView explicit
			title: 'Body' translated;
			priority: 20;
			stencil: [ aSnippetElement asScrollableElement ] ].
	
	^ aView textEditor
		title: 'Body' translated;
		priority: 20;
		text: [ self bodyTextFormatted ]
]
