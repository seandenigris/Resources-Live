baselines
baseline: spec
	<baseline>

	spec for: #'common' do: [
		spec project: 'SimplePersistence' with: [
				spec
					className: #ConfigurationOfSimplePersistence;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/TorstenBergmann/SimplePersistence/main/' ].
		spec package: #ResourcesLive with: [
				spec requires: #('SimplePersistence' ). ]. ].
