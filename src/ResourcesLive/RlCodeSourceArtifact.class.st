"
I represent one generated source file belonging to an RlCodeSelectionMaterialization.

My path is relative to an export root. I provide a GT text view of my contents and know how to write myself beneath a directory.
"
Class {
	#name : 'RlCodeSourceArtifact',
	#superclass : 'Object',
	#instVars : [
		'relativePath',
		'contents'
	],
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RlCodeSourceArtifact class >> relativePath: aString contents: sourceContents [
	^ self new
		relativePath: aString;
		contents: sourceContents;
		yourself

]

{ #category : 'accessing' }
RlCodeSourceArtifact >> contents [
	^ contents

]

{ #category : 'accessing' }
RlCodeSourceArtifact >> contents: aString [
	contents := aString

]

{ #category : 'gt - views' }
RlCodeSourceArtifact >> gtContentsFor: aView [
	<gtView>

	^ aView text
		title: 'Source';
		priority: 1;
		text: [ self contents ];
		styler: [ BrSmalltalkSyntaxStyler new ];
		yourself

]

{ #category : 'printing' }
RlCodeSourceArtifact >> printOn: aStream [
	aStream nextPutAll: self relativePath

]

{ #category : 'accessing' }
RlCodeSourceArtifact >> relativePath [
	^ relativePath

]

{ #category : 'accessing' }
RlCodeSourceArtifact >> relativePath: aString [
	relativePath := aString

]

{ #category : 'accessing' }
RlCodeSourceArtifact >> size [
	^ self contents size

]

{ #category : 'exporting' }
RlCodeSourceArtifact >> writeUnder: aDirectory [
	| target |

	target := aDirectory / self relativePath.
	target parent ensureCreateDirectory.
	target writeStreamDo: [ :stream |
		stream nextPutAll: self contents ].

	^ target

]
