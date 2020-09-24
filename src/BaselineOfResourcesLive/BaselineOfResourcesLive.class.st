Class {
	#name : #BaselineOfResourcesLive,
	#superclass : #BaselineOf,
	#category : #BaselineOfResourcesLive
}

{ #category : #accessing }
BaselineOfResourcesLive class >> exampleSupportFolder [
	^ FileLocator localDirectory / 'iceberg' / 'seandenigris' / 'Resources-Live'/ 'example support'
]

{ #category : #baselines }
BaselineOfResourcesLive >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec
			baseline: 'PharoEnhancements' with: [
				spec repository: 'github://seandenigris/Pharo-Enhancements' ];
			baseline: 'SimplePersistence' with: [
				spec repository: 'github://seandenigris/Simple-Persistence' ];
			baseline: 'Superuser' with: [
				spec repository: 'github://seandenigris/Superuser' ].
		spec package: #ResourcesLive with: [
				spec requires: #('PharoEnhancements' 'SimplePersistence' 'Superuser'). ]. ].

]
