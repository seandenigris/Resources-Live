Class {
	#name : 'RlMpvJSONDriver',
	#superclass : 'Object',
	#instVars : [
		'pythonMpv'
	],
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'accessing' }
RlMpvJSONDriver >> currentTime [
	^ self pythonMpv newCommandFactory
		<< (self pythonMpv => #time_pos);
		sendAndWait
]

{ #category : 'accessing' }
RlMpvJSONDriver >> exampleCommand [

	LibC resultOfCommand: 'echo ''{ "command": ["get_property", "playback-time"] }'' | /opt/homebrew/bin/socat - /tmp/mpvsocket'
]

{ #category : 'accessing' }
RlMpvJSONDriver >> filename [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #filename);
		sendAndWait
]

{ #category : 'as yet unclassified' }
RlMpvJSONDriver >> isPlaying [
	| isPaused |
	self filename ifNil: [ ^ false ].
	isPaused := self pythonMpv newCommandFactory
		<< (self pythonMpv => #pause);
		sendAndWait.
	^ isPaused not
]

{ #category : 'accessing' }
RlMpvJSONDriver >> onQuit [
	self terminate
]

{ #category : 'accessing' }
RlMpvJSONDriver >> pause [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #pause <- true);
		send
]

{ #category : 'accessing' }
RlMpvJSONDriver >> play [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #pause <- false);
		send
]

{ #category : 'accessing' }
RlMpvJSONDriver >> pythonMpv [
	pythonMpv ifNotNil: [ ^ pythonMpv ].
	
	^ pythonMpv := PBApplication uniqueInstance 
		sendSource: 'import mpv
import mpvsilence
mpv.MPV()' 
		withBindings: {}
]

{ #category : 'as yet unclassified' }
RlMpvJSONDriver >> seekTo: aDuration [ 
	"player.seek(offset, reference=""absolute"")"
	
	self pythonMpv newCommandFactory
		<< (P3GCall target: self pythonMpv => #seek  positionalArguments: { aDuration asSeconds } keywordArguments: { #reference -> 'absolute' } asDictionary);
		sendAndWait.
]

{ #category : 'accessing' }
RlMpvJSONDriver >> show: media [
	"PBApplication uniqueInstance 
		sendSource: 'player.play(filename)'
		withBindings: { 
			#player -> self pythonMpv.
			#filename -> aFile fullName }."
	self pythonMpv newCommandFactory
		<< (P3GCall target: self pythonMpv => #play  positionalArguments: { media file fullName });
		sendAndWait.
	self pause.
	^ self "I am the container because I don't have e.g. tabs"
]

{ #category : 'accessing' }
RlMpvJSONDriver >> skipSilence [
	PBApplication uniqueInstance newCommandFactory
		<< (P3GCall 
				target: self pythonMpv => #skip_silence
				positionalArguments: nil 
				keywordArguments: { 
					#noise -> -40.
					#duration -> 1 } asDictionary);
		sendAndWait.
]

{ #category : 'accessing' }
RlMpvJSONDriver >> speed [
	^ self pythonMpv newCommandFactory
		<< (self pythonMpv => #speed);
		sendAndWait
]

{ #category : 'accessing' }
RlMpvJSONDriver >> speed: aNumber [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #speed <- aNumber);
		send
]

{ #category : 'accessing' }
RlMpvJSONDriver >> terminate [
	
	self pythonMpv newCommandFactory
		<< (P3GCall target: self pythonMpv => #terminate);
		sendAndWait.
]
