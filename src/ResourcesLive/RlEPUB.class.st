"
# File Format
## Version 2.0.1
A zip archive with the following...
### Metadata
The OPF file, traditionally named `content.opf`, houses the EPUB book's metadata, file manifest, and linear reading order
### TOC

"
Class {
	#name : 'RlEPUB',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core'
}

{ #category : 'accessing' }
RlEPUB class >> example [
	<gtExample>
	^ (FileLocator home / 'Dropbox (Personal)/Calibre Library/Chris Voss/Never Split the Difference_ Negotia (131)/Never Split the Difference_ Neg - Chris Voss.epub') asRlResource
]

{ #category : 'accessing' }
RlEPUB class >> fileExtensions [
	^ #('epub')
]

{ #category : 'views' }
RlEPUB >> gtArchiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Archive';
		object: [ self file ];
		view: #gtInspectorZipItemsIn:
		
]

{ #category : 'accessing' }
RlEPUB >> metadataFile [
	| opfFiles |
	"NB: ZIP store doesn't have to be closed because as an in-memory store it doesn't open external resources, and shouldn't be here because it would save the unchanged zip archive"
	opfFiles := (FileSystem zip: self file) open workingDirectory filesMatching: '*.opf'.
	self assert: opfFiles size equals: 1.
	^ RlEpubOpfFileReference newFrom: opfFiles first
]
