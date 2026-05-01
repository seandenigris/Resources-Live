Class {
	#name : 'RlDomYouTubeVideo',
	#superclass : 'RlDomVideo',
	#category : 'ResourcesLive-Web Driving',
	#package : 'ResourcesLive',
	#tag : 'Web Driving'
}

{ #category : 'as yet unclassified' }
RlDomYouTubeVideo >> currentTime [

	| secondsString |
	secondsString := self moviePlayerDoJavascript: 'getCurrentTime()'.
	^ secondsString asNumber seconds
]

{ #category : 'as yet unclassified' }
RlDomYouTubeVideo >> moviePlayerDoJavascript: aString [
	"Player API Reference: https://developers.google.com/youtube/iframe_api_reference"

	| playerElement |
	
	self page exists ifFalse: [ self error: 'Page does not exist: ', self page url asString ].
	
	playerElement := self page domElementFromSelector: '#movie_player'.
	^ playerElement selfEvaluate: aString.
]

{ #category : 'as yet unclassified' }
RlDomYouTubeVideo >> pause [
	^ self moviePlayerDoJavascript: 'pauseVideo()'.
]

{ #category : 'as yet unclassified' }
RlDomYouTubeVideo >> play [
	^ self moviePlayerDoJavascript: 'playVideo()'.
]

{ #category : 'as yet unclassified' }
RlDomYouTubeVideo >> seekTo: aDuration [
	
	| template js myDuration safeDuration |
	
	"If we try to seek past the end of the video, the currentTime does not update correctly"
	myDuration := self duration.
	safeDuration := aDuration min: myDuration.
	
	template := 'seekTo({seconds}, {allowSeekAhead})'.
	js := template format: { 
		#seconds -> safeDuration asSeconds. 
		#allowSeekAhead -> true } asDictionary.
	^ self moviePlayerDoJavascript: js.
]
