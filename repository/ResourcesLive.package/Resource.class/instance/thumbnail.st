private
thumbnail

	| tempFilePath commandTemplate command thumbnail |
	tempFilePath := Resources temporaryDirectory fullNameFor: 'thumbnail.jpg'.
	commandTemplate := '/opt/local/bin/gs -dFirstPage=1 -dLastPage=1 -sDEVICE=jpeg -sOutputFile="{1}" -dBATCH -dNOPAUSE -q  "{2}"'.
	command := commandTemplate format: { tempFilePath. file fullName }.
	OSProcess command: command.
	thumbnail := Form fromFileNamed: tempFilePath.
	^ thumbnail 