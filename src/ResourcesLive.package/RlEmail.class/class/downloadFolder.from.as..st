utilities
downloadFolder: remoteFolder from: server as: user
	
	| rootFolder commandTemplate command uniqueMessages allMessages |
	rootFolder := FileLocator home / 'Downloads' / 'Email Archive'.
	commandTemplate := 'cd "{rootFolder}"; python dump-imap.py -s {server} -u {user} -r "{remoteFolder}"'.
	command := commandTemplate format: { 
		#rootFolder -> rootFolder fullName.
		#server -> server.
		#user -> user.
		#remoteFolder -> remoteFolder } asDictionary.
	LibC system: command.
	uniqueMessages := PluggableSet new
		equalBlock: [ :a :b | a isMD5Equal: b ];
		hashBlock: [ :f | f binaryReadStreamDo: [ :str | (MD5 hashStream: str) hex hash ] ]
		yourself.
	allMessages := (rootFolder / 'Downloads' / remoteFolder) filesMatching: '*.eml'.
	uniqueMessages addAll: allMessages.
	(allMessages difference: uniqueMessages) do: #delete.
	self renameFilesIn: rootFolder / 'Downloads' / remoteFolder