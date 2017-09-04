baselines
baseline: spec
	<baseline>

	spec for: #'common' do: [
		spec baseline: 'SimplePersistence' with: [
				spec
					repository: 'github://seandenigris/Simple-Persistence:master/repository';
					postLoadDoIt: #setUpSimplePersistence ].
		spec package: #ResourcesLive with: [
				spec requires: #('SimplePersistence' ). ]. ].
