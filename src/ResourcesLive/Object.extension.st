Extension { #name : #Object }

{ #category : #'*ResourcesLive' }
Object >> rlImportInto: aRlResourceLibrary [
	"Used internally by libraries during import to simplify API by making objects polymorphic"
	
	^ RlLibraryImport new
		resource: self;
		library: aRlResourceLibrary;
		execute.
]
