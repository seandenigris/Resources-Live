scripts
verifyProperFiling
	<script>
	| misfiled |
	misfiled := RlResourceLibrary uniqueInstance resources select: [ :e | (e isKindOf: self) and: [ e file parent base ~= 'Read_Review' and: [e file parent base ~= ('20', (e file base first: 2)) ] ] ].
	misfiled ifNotEmpty: [ self error: 'Found misfiled emails!' ]