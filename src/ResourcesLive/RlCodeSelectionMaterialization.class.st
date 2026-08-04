"
I am an immutable materialization of one load-plan selection.

I reconstruct the selected changes as valid source artifacts, parse those artifacts again through the ordinary source-format reader, verify the round trip before loading, expose the generated files for inspection, and can export them beneath a supplied directory.
"
Class {
	#name : 'RlCodeSelectionMaterialization',
	#superclass : 'Object',
	#instVars : [
		'plan',
		'selectedChanges'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RlCodeSelectionMaterialization class >> on: anRlCodeLoadPlan [
	^ self new
		initializeOn: anRlCodeLoadPlan;
		yourself

]

{ #category : 'loading' }
RlCodeSelectionMaterialization >> apply [
	self subclassResponsibility

]

{ #category : 'validation' }
RlCodeSelectionMaterialization >> assertValid [
	| errors |

	errors := self validationErrors.
	errors ifEmpty: [ ^ self ].

	self error:
		(String streamContents: [ :stream |
			stream
				nextPutAll: 'The selected source could not be materialized safely:';
				cr.

			errors do: [ :message |
				stream
					nextPutAll: '- ';
					nextPutAll: message;
					cr ] ])

]

{ #category : 'accessing' }
RlCodeSelectionMaterialization >> codeSource [
	^ self plan codeSource

]

{ #category : 'gt - views' }
RlCodeSelectionMaterialization >> gtArtifactsFor: aView [
	<gtView>

	^ aView list
		title: 'Source artifacts';
		priority: 1;
		items: [ self sourceArtifacts ];
		itemText: #relativePath;
		send: #yourself;
		yourself

]

{ #category : 'testing' }
RlCodeSelectionMaterialization >> hasSelection [
	^ self selectedChanges isNotEmpty

]

{ #category : 'hazards' }
RlCodeSelectionMaterialization >> hazardMessages [
	^ #()

]

{ #category : 'initialization' }
RlCodeSelectionMaterialization >> initializeOn: anRlCodeLoadPlan [
	plan := anRlCodeLoadPlan.
	selectedChanges := anRlCodeLoadPlan selectedChangesInSourceOrder asArray

]

{ #category : 'accessing' }
RlCodeSelectionMaterialization >> plan [
	^ plan

]

{ #category : 'validation' }
RlCodeSelectionMaterialization >> preflightValidationErrors [
	self subclassResponsibility

]

{ #category : 'printing' }
RlCodeSelectionMaterialization >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		print: self selectedChanges size;
		nextPutAll: ' selected changes)'

]

{ #category : 'validation' }
RlCodeSelectionMaterialization >> roundTripValidationErrors [
	self subclassResponsibility

]

{ #category : 'accessing' }
RlCodeSelectionMaterialization >> selectedChanges [
	^ selectedChanges

]

{ #category : 'accessing' }
RlCodeSelectionMaterialization >> sourceArtifacts [
	self subclassResponsibility

]

{ #category : 'validation' }
RlCodeSelectionMaterialization >> validationErrors [
	| errors |

	errors := OrderedCollection new.

	[
		errors addAll: self preflightValidationErrors.
		errors ifEmpty: [
			errors addAll: self roundTripValidationErrors ] ]
				on: Error
				do: [ :error |
					errors add:
						'Source materialization failed: '
							, error messageText asString ].

	^ errors

]

{ #category : 'exporting' }
RlCodeSelectionMaterialization >> writeTo: aDirectory [
	| root |

	self assertValid.
	root := aDirectory asFileReference.
	root ensureCreateDirectory.

	self sourceArtifacts do: [ :artifact |
		artifact writeUnder: root ].

	^ root

]
