"
Per *http://idpf.org/epub/20/spec/OPF_2.0.1_draft.htm*:
==An XML Document that describes an OPS Publication and references all files used by the OPS Publication that are not part of the OPF Package Document itself. It identifies all other files in the Publication and provides descriptive information about them. The OPF Package Document is defined by this specification and is valid to the OPF Package Schema defined herein.
The ""root file"" of the OPF Package Document should use the .opf extension. This XML file may refer to other XML files via XML’s general entity mechanism, but those files must not use the .opf file extension. This construction could be used to simplify the creation of OPF Package Documents for very large Publications. However, the most common case is for the OPF Package Document to be a single XML file using the .opf extension.==
"
Class {
	#name : #RlEpubOpfFileReference,
	#superclass : #FileReference,
	#category : #'ResourcesLive-EPUB'
}

{ #category : #examples }
RlEpubOpfFileReference class >> example [
	<gtExample>
	^ self newFrom: RlEPUB example metadataFile
]

{ #category : #examples }
RlEpubOpfFileReference class >> exampleAuthors [
	<gtExample>
	self assert: self example authors size equals: 2
]

{ #category : #examples }
RlEpubOpfFileReference class >> exampleManifest [
	<gtExample>
	| result |
	result := self example manifest.
	self assert: (result isKindOf: Collection).
	^ result
]

{ #category : #examples }
RlEpubOpfFileReference class >> examplePublicationDate [
	<gtExample>
	self assert: (self example publicationDate isKindOf: DateAndTime)
]

{ #category : #examples }
RlEpubOpfFileReference class >> examplePublisher [
	<gtExample>
	self assert: (self example publisher isKindOf: String)
]

{ #category : #examples }
RlEpubOpfFileReference class >> exampleTitle [
	<gtExample>
	self assert: (self example title isKindOf: String)
]

{ #category : #accessing }
RlEpubOpfFileReference >> authors [
	"Per http://idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#TOC2.2.2 :
		Listed in the order in which they should appear. Actually, not all creators are authors. If we want to get more specific, consult https://id.loc.gov/vocabulary/relators.html for the meaning of the nodes' code attribute"
	| authorNodes |
	authorNodes := (XMLDOMParser parse: self contents) xpath: '//dc:creator'.
	^ authorNodes collect: [ :n | n stringValue ] as: Array
]

{ #category : #accessing }
RlEpubOpfFileReference >> manifest [
	"
	'It's the source of ID's to everything else... A list of all the files included in the package... Every file in the ePub must be listed in the manifest.' - per http://apex.infogridpacific.com/df/ePubSpineOrder-packaging10.html
	
	Reference: http://idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#TOC2.3"
	| authorNodes |
	authorNodes := (XMLDOMParser parse: self contents) xpath: '//manifest[1]/*'. "XPath adapted from https://stackoverflow.com/a/44157593/424245"
	^ authorNodes asArray
]

{ #category : #accessing }
RlEpubOpfFileReference >> publicationDate [
	| matchingNodes |
	matchingNodes := (XMLDOMParser parse: self contents) // 'dc:date'.
	^ DateAndTime fromString: (matchingNodes collect: [ :n | n stringValue ]) first
]

{ #category : #accessing }
RlEpubOpfFileReference >> publisher [
	| authorNodes |
	authorNodes := (XMLDOMParser parse: self contents) // 'dc:publisher'.
	^ (authorNodes collect: [ :n | n stringValue ]) first
]

{ #category : #accessing }
RlEpubOpfFileReference >> title [
	| matchingNodes |
	"Per http://idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#TOC2.2.1 :
		Must include at least one title element. Can implement algorithm to determine most appropriate, or consider either the first or all elements most appropriate"
	matchingNodes := (XMLDOMParser parse: self contents) // 'dc:title'.
	^ (matchingNodes collect: [ :n | n stringValue ]) first
]
