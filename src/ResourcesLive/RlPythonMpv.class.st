Class {
	#name : 'RlPythonMpv',
	#superclass : 'Object',
	#instVars : [
		'pythonMpv'
	],
	#category : 'ResourcesLive-Media Playing',
	#package : 'ResourcesLive',
	#tag : 'Media Playing'
}

{ #category : 'accessing' }
RlPythonMpv >> currentTime [
	^ self pythonMpv newCommandFactory
		<< (self pythonMpv => #time_pos);
		sendAndWait
]

{ #category : 'accessing' }
RlPythonMpv >> filename [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #filename);
		sendAndWait
]

{ #category : 'as yet unclassified' }
RlPythonMpv >> isPlaying [
	| isPaused |
	self filename ifNil: [ ^ false ].
	isPaused := self pythonMpv newCommandFactory
		<< (self pythonMpv => #pause);
		sendAndWait.
	^ isPaused not
]

{ #category : 'accessing' }
RlPythonMpv >> onQuit [
	self terminate
]

{ #category : 'accessing' }
RlPythonMpv >> pause [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #pause <- true);
		send
]

{ #category : 'accessing' }
RlPythonMpv >> play [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #pause <- false);
		send
]

{ #category : 'accessing' }
RlPythonMpv >> pythonMpv [
	pythonMpv ifNotNil: [ ^ pythonMpv ].
	
	^ pythonMpv := PBApplication uniqueInstance 
		sendSource: 'import mpv
import mpvsilence
mpv.MPV()' 
		withBindings: {}
]

{ #category : 'as yet unclassified' }
RlPythonMpv >> seekTo: aDuration [ 
	"player.seek(offset, reference=""absolute"")"
	
	self pythonMpv newCommandFactory
		<< (P3GCall target: self pythonMpv => #seek  positionalArguments: { aDuration asSeconds } keywordArguments: { #reference -> 'absolute' } asDictionary);
		sendAndWait.
]

{ #category : 'accessing' }
RlPythonMpv >> show: media [
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

{ #category : 'playing' }
RlPythonMpv >> skipSilence [
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
RlPythonMpv >> speed [
	^ self pythonMpv newCommandFactory
		<< (self pythonMpv => #speed);
		sendAndWait
]

{ #category : 'accessing' }
RlPythonMpv >> speed: aNumber [
	self pythonMpv newCommandFactory
		<< (self pythonMpv => #speed <- aNumber);
		send
]

{ #category : 'accessing' }
RlPythonMpv >> terminate [
	
	self pythonMpv newCommandFactory
		<< (P3GCall target: self pythonMpv => #terminate);
		sendAndWait.
]
