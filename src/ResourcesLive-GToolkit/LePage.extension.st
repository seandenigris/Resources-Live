Extension { #name : #LePage }

{ #category : #'*ResourcesLive-GToolkit' }
LePage >> asRTF [
	
	^ RlRTF fromMarkdown: self asMarkdownString
]
