as yet unclassified
initialize
	"self initialize"

	self libraryDirectory ensureCreateDirectory.
	self temporaryDirectory ensureCreateDirectory.
	ExternalDropHandler registerHandler: self defaultPdfHandler.
	"FolderActions enable."