Class {
	#name : #BaselineOfResourcesLive,
	#superclass : #BaselineOf,
	#category : #BaselineOfResourcesLive
}

{ #category : #baselines }
BaselineOfResourcesLive >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec
			baseline: 'SimplePersistence' with: [
				spec repository: 'github://seandenigris/Simple-Persistence' ];
			baseline: 'PharoEnhancements' with: [
				spec repository: 'github://seandenigris/Pharo-Enhancements' ].
		spec package: #ResourcesLive with: [
				spec requires: #('SimplePersistence' 'PharoEnhancements'). ]. ].

]
