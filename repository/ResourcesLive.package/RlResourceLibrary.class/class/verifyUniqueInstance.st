as yet unclassified
verifyUniqueInstance
	<script>

	| resources d sourced duplicates  |

	"Find resources from the same source (i.e. URL)"
	resources := RlResourceLibrary uniqueInstance resources.
	d := Dictionary new.
	sourced := resources reject: [ :e | e source isNil ].
	sourced
		do: [ :e | 
			| key |
			key := e source.
			d at: key ifPresent: [ :a | (d at: key) add: e ] ifAbsent: [ d at: key put: (OrderedCollection with: e) ] ].
	duplicates := d values select: [ :col | col size > 1 ].
	
	"Find objects appearing multiple times"
	self assert: resources size = resources asIdentitySet size.