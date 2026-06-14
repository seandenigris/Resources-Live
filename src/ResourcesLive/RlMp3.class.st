"
# Merging Multiple Files
Try {{gtClass:Su_mp3cat}}.

NB. There is some info online about simply using cat, but that did not work for me. Others have had problems as well, apparently due to corrupted metainfo. Finder only played through the portion from the first file even though the combined file size was about right.

"
Class {
	#name : 'RlMp3',
	#superclass : 'RlResource',
	#category : 'ResourcesLive-Core',
	#package : 'ResourcesLive',
	#tag : 'Core'
}

{ #category : 'examples' }
RlMp3 class >> example [
	<gtExample>
	| result |
	result := self on: self exampleSupportFolder / 'beep.mp3'.
	result play.
	^ result
]

{ #category : 'file types' }
RlMp3 class >> fileExtensions [
	^ #('mp3')
]

{ #category : 'utilities' }
RlMp3 class >> merger [
	^ SuMp3cat new.
	
	"Implementation note: NB. There is some info online about simply using cat, but that did not work for me. Others have had problems as well, apparently due to corrupted metainfo. Finder only played through the portion from the first file even though the combined file size was about right."
]

{ #category : 'playing' }
RlMp3 >> defaultDriverClass [
	^ RlPythonMpv
]

{ #category : 'playing' }
RlMp3 >> play [
	^ self playCli
	
	"If playing stuff moved from Living Library to Resources Live, could (should?) be: self newPlayer
		play;
		yourself"
]

{ #category : 'playing' }
RlMp3 >> playCli [
	LibC system: 'afplay ', self file fullName surroundedBySingleQuotes, ' &'.
]

{ #category : 'accessing' }
RlMp3 >> playDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #play;
		yourself
]

{ #category : 'playing' }
RlMp3 >> playSlow [
	
	LibC system: 'afplay -r 0.5 ', self file fullName surroundedBySingleQuotes, ' &'.
]

{ #category : 'playing' }
RlMp3 >> playableClass [
	^ RlContainedMedia
]

{ #category : 'playing' }
RlMp3 >> playerClass [
	^ RlMediaPlayer
]
