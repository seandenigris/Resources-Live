as yet unclassified
initialize
	"self initialize"

	self folder ensureCreateDirectory.
	self temporaryFolder ensureCreateDirectory.
	ExternalDropHandler registerHandler: self defaultPdfHandler.
	"FolderActions enable."