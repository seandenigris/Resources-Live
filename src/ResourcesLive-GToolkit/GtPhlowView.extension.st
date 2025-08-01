Extension { #name : #GtPhlowView }

{ #category : #'*ResourcesLive-GToolkit' }
GtPhlowView >> actionUpdateButtonUncaching: anObject [

	self
		actionButtonIcon: BrGlamorousVectorIcons refresh
		tooltip: 'Update'
		action: [ :aButton :aTab | 
			anObject cacheReset.
			aTab viewContentElement phlow update ]
]
