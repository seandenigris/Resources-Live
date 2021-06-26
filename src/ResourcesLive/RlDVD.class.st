"
# Ripping
The easiest way seems to be to use the Handbrake tool. However, there doesn't seem to be one group of settings that is optimal for every situation.
## Scenarios
Per [winxdvd](https://www.winxdvd.com/resource/best-handbrake-settings-for-dvd-to-mp4.htm), here are some setting suggestions:
- Mp4 - best balance of speed, size and quality - use medium presets; possibly doing a 3-5 minute trial to check and tweak
- Plex
	- if it is a interlaced DVD, you need to enable Decomb and Detelecine
	- Video Codec: H.264 (X264)
	- Framerate (fps):30; Peak Framerate
	- Encoder Preset: Slower
	- Encoder Tune: Film
	- Encoder Profile: High
	- Encoder Level: 4.1
	- Constant Quality: 18
	- As for the Audio tab, you can change the Mixdown to 5.1 Channels (if there is) to get surround sound. Or you can choose Stereo. Bitrate 160 is ok.

"
Class {
	#name : #RlDVD,
	#superclass : #RlPhysicalResource,
	#category : #'ResourcesLive-Core'
}

{ #category : #accessing }
RlDVD >> rip [
	
	self inform: 'See ', self className, '''s class comment, "Ripping" section'.
	
	"Implementation (or lack thereof) note: I could spend a lot of time programmatizing this, but at the end of the day, will it be worth the effort? How much faster/easier will it be vs. just following the fairly simple directions?"
]
