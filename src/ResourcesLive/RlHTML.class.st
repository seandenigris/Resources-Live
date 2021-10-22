Class {
	#name : #RlHTML,
	#superclass : #RlResource,
	#category : 'ResourcesLive-Core'
}

{ #category : #'file types' }
RlHTML class >> fileExtensions [
	^ #('html')
]

{ #category : #accessing }
RlHTML >> clip [
	| tempFile command |
	OSPlatform current isMacOSX ifFalse: [ self error: 'Only implemented on Mac OSX' ].
	[ 
		tempFile := FileReference newTempFilePrefix: 'htmllink' suffix: 'txt'.
		tempFile writeStreamDo: [ :s | s nextPutAll: self file contents ].
		command := '/usr/bin/textutil -format html -convert rtf -stdout ' , (tempFile fullName surroundedBy: '"') , ' | /usr/bin/pbcopy'.
		LibC system: command
	] ensure: [ tempFile delete ]

	"Implementation note: the first attempt was to pass the input via a HEREDOC, but that didn't seem to work with LibC"
]

{ #category : #utilities }
RlHTML >> edit [
	LibC system: 'open -a MacVim "', self file fullName, '"'.
]

{ #category : #utilities }
RlHTML >> soup [
	^ Soup fromString: self file contents
]
