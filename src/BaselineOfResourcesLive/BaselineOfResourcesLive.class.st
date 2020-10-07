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
			baseline: 'Magritte' with: [
				spec repository: 'github://seandenigris/Magritte' ];
			baseline: 'NeoCSV' with: [
				spec repository: 'github://seandenigris/NeoCSV' ];
			baseline: 'PharoEnhancements' with: [
				spec repository: 'github://seandenigris/Pharo-Enhancements' ];
			baseline: 'SimplePersistence' with: [
				spec repository: 'github://seandenigris/Simple-Persistence' ];
			baseline: 'Soup' with: [
				spec repository: 'github://seandenigris/Soup-for-Pharo' ];
			baseline: 'Superuser' with: [
				spec repository: 'github://seandenigris/Superuser' ];
			baseline: 'Tempfile' with: [
				spec repository: 'github://seandenigris/TempfileSt' ];
			baseline: 'Tesseract' with: [
				spec
					repository: 'github://seandenigris/Tesseract-St' ].
		spec package: #ResourcesLive with: [
				spec
					requires: #('Magritte' 'NeoCSV' "for RlCsvFile" 'PharoEnhancements' 'SimplePersistence' 'Soup' "for RlHTML" 'Superuser' 'Tempfile');
					includes: #('Tesseract'). ]. ].
	spec for: #'GToolkit' do: [	
		spec 
			package: #'ResourcesLive-GToolkit' with: [
				spec requires: #('ResourcesLive'). ];
			package: #ResourcesLive with: [
				spec includes: #('ResourcesLive-GToolkit') ]. ].
]

{ #category : #accessing }
BaselineOfResourcesLive >> customProjectAttributes [
	^ self isGTImage
			ifFalse: [ #() ]
			ifTrue: [ #(GToolkit) ]
]

{ #category : #testing }
BaselineOfResourcesLive >> isGTImage [
	^ RPackageOrganizer default packageNames anySatisfy: [ :pn | pn beginsWith: 'GToolkit-' ]
]
