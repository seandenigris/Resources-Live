"
!! Motivation
What is a file? A file is data, which often represents something in a user's domain e.g. a photo. Files that matter to users have a label e.g. ==/Users/me/image_1.jpg==. This label consists of a name and a location - although with the advent of universal search (e.g. Mac Spotlight) one could debate how useful/interesting the location is in many cases. Typically the location is thought of as a concrete place. The filesystem is like an organized closet, where the closet is subdivided into shelves, and then the shelves are subdivided into plastic bins, etc.

But what does any of the above have to do with what matters? If we take a photo, and that photo happens to be stored digitally, why can't we deal with it abstractly so that we don't have to know or care what its label is or where its bits are stored?

One problem with the filesystem paradigm is that files need to be in one place, and can be linked to other places. This creates tension. The first pain point is balancing navigability and maintenance. If I have one giant folder, it can be hard to find any given thing, but if I have a folder tree 6 levels deep, it can be a maintenance headache, as well as requiring effort to drill down through all those levels.

The next pain point is where real-life categories aren't cleanly separated. Let's say I work for a company, and also belong to an employee union. I am interviewed about an issue on which the company and the union are aligned. Where do I put the video of the interview? In the company folder? In the union folder? Yes, I could symlink from one to the other, but the point is that it really belongs to both domains equally and filesystems don't support that concept. Also, linking doesn't work for all use cases e.g. syncing services like Dropbox and Google Sync can't properly handle them.

So we're mixing two concepts. What a digital thing is, and what it represents in the real world. ResourcesLive is an attempt to disentangle these two. It's mission is to handle the first - the digital entity, the file - magically for the user, although the user should be able to customize if they really care. It then models the second concept - what the digital thing represents in the real world - on it's own terms. So an image file might have #edit and #view capabilities, a sound can be #play-ed, etc.

! Installation
The target platform where it's most likely to work well is latest Pharo/GToolkit.

[[[language=smalltalk
EpMonitor current disable.
Metacello new
	baseline: 'ResourcesLive';
	repository: 'github://seandenigris/ResourcesLive';
	load.
EpMonitor current enable
]]]

!Usage
A typical use case is to have a resource library particular to your project. E.g. a library of mp3 files for a music app. We'll take that example, and assume you're using SimplePersistence to store your data.

1. Set File Library location. Otherwise, the default will use a system-wide location. NB Be careful with this because there is no conflict management if you have multiple images/apps using the same library. ResourcesLive uses its backup directory to determine the library location, so:

[[[language=smalltalk|methodDefinition=true
    MyProjectDB class>>initialize
    	""Add the following line *before* you send #restoreLastBackup""
    	ResourcesLiveDB backupDirectoryParent: self backupDirectoryParent.
]]]
 
2. Set up serialization

[[[language=smalltalk|methodDefinition=true
    MyProjectDB class>>schema
    	^ { MyProject. MyProject. ResourcesLiveDB }.
]]]
"
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
