"
# Merging Multiple Files
Try {{gtClass:Su_mp3cat}}.

NB. There is some info online about simply using cat, but that did not work for me. Others have had problems as well, apparently due to corrupted metainfo. Finder only played through the portion from the first file even though the combined file size was about right.

"
Class {
	#name : #RlMp3,
	#superclass : #RlResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #examples }
RlMp3 class >> example [
	<gtExample>
	| result |
	result := self on: self exampleSupportFolder / 'beep.mp3'.
	result play.
	^ result
]

{ #category : #'file types' }
RlMp3 class >> fileExtensions [
	^ #('mp3')
]

{ #category : #utilities }
RlMp3 class >> merger [
	^ SuMp3cat new.
	
	"Implementation note: NB. There is some info online about simply using cat, but that did not work for me. Others have had problems as well, apparently due to corrupted metainfo. Finder only played through the portion from the first file even though the combined file size was about right."
]

{ #category : #'as yet unclassified' }
RlMp3 >> currentTimeIn: container [
	^ container currentTime
]

{ #category : #'as yet unclassified' }
RlMp3 >> isPlayingIn: container [
	^ container isPlaying
]

{ #category : #accessing }
RlMp3 >> pauseIn: container [
	container pause
]

{ #category : #'as yet unclassified' }
RlMp3 >> play [
	LibC system: 'afplay ', self file fullName surroundedBySingleQuotes, ' &'.
]

{ #category : #accessing }
RlMp3 >> playDescription [
	<magritteActionDescription>
	^ MAActionDescription new
		action: #play;
		yourself
]

{ #category : #'as yet unclassified' }
RlMp3 >> playSlow [
	
	LibC system: 'afplay -r 0.5 ', self file fullName surroundedBySingleQuotes, ' &'.
]

{ #category : #'as yet unclassified' }
RlMp3 >> playbackSpeed: aNumber in: container [
	container speed: aNumber
]

{ #category : #'as yet unclassified' }
RlMp3 >> playbackSpeedIn: container [
	^ container speed
]

{ #category : #'as yet unclassified' }
RlMp3 >> seekTo: aDuration in: container [
	container seekTo: aDuration
]
