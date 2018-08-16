as yet unclassified
allFileExtensions
	^ self subclasses flatCollect: [ :klass | klass fileExtensions ]