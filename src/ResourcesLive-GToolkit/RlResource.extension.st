Extension { #name : #RlResource }

{ #category : #'*ResourcesLive-GToolkit' }
RlResource class >> markdown: aString gtViewOn: aView do: aBlock [

	| snip viewModel aSnippetElement result |
	snip := LeTextSnippet string: aString.
	viewModel := snip asSnippetViewModel.
	aSnippetElement := viewModel snippetView asElement.
	aSnippetElement snippetViewModel: viewModel.
	
	result := aView explicit
		title: 'Contents' translated;
		priority: 20;
		stencil: [ aSnippetElement asScrollableElement ].
	aBlock cull: result.
	
	^ result
]
