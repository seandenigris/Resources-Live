Class {
	#name : 'RlMediaPlayerElement',
	#superclass : 'BrHorizontalPane',
	#instVars : [
		'player'
	],
	#category : 'ResourcesLive-GToolkit-Media Playing',
	#package : 'ResourcesLive-GToolkit',
	#tag : 'Media Playing'
}

{ #category : 'instance creation' }
RlMediaPlayerElement class >> on: aPlayer [

	^ self new
		player: aPlayer;
		yourself
]

{ #category : 'accessing' }
RlMediaPlayerElement >> initialize [

	| buttons |
	super initialize.
	
	self
		fitContent;
		cellSpacing: 5.
	
	buttons := { 
		BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Play';
			icon: BrGlamorousVectorIcons play;
			action: [ self player togglePlayPause ].
			
		BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Quit';
			icon: BrGlamorousVectorIcons shutdown;
			action: [ self player quit ].
		
		BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Slower';
			icon: BrGlamorousVectorIcons downwards;
			action: [ self player speed: self player speed / 2 ].
			
		BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Faster';
			icon: BrGlamorousVectorIcons upwards;
			action: [ self player speed: self player speed * 2 ].
			
		BrButton new 
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: '<<';
			action: [ self player seekBy: -5 seconds ].
			
		BrButton new 
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: '>>';
			action: [ self player seekBy: 5 seconds ].
				
		BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Next section';
			icon: BrGlamorousVectorIcons right;
			action: [ self player nextSection ].
			
		BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Inspect player';
			icon: BrGlamorousVectorIcons inspect;
			action: [ :aButton | aButton phlow spawnObject: self player ].
	}.
	
	buttons do: [ :b | self addChild: b ].
	^ self.
]

{ #category : 'accessing' }
RlMediaPlayerElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	self flag: 'self player quit` doesn''t work because there is no foolproof hook to know when an element is no longer needed. There is also no way to customize the page view model, so for now, we''ll have to quit manually.'
]

{ #category : 'accessing' }
RlMediaPlayerElement >> player [

	^ player
]

{ #category : 'accessing' }
RlMediaPlayerElement >> player: anObject [

	player := anObject
]
