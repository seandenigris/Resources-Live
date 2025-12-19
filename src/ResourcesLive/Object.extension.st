Extension { #name : 'Object' }

{ #category : '*ResourcesLive' }
Object >> rlImportInto: aRlResourceLibrary [
	"Used internally by libraries during import to simplify API by making objects polymorphic"
	
	^ RlLibraryImport new
		resourceable: self;
		library: aRlResourceLibrary;
		execute.
]
