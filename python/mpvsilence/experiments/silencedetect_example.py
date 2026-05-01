#Kill w ctrl-c

import os

file_path = os.path.dirname(os.path.realpath(__file__))

import mpv

def my_log(loglevel, component, message):
  return  
  #print('[{}] {}: {}'.format(loglevel, component, message))

player = mpv.MPV(log_handler=my_log,loglevel='v')

print(file_path + "/sample_w_silence.m4a")

player.play(file_path + "/sample_w_silence.m4a")
@player.event_callback('log-message')
def my_handler(event):
  eventText = event['event']['text']
  if not eventText.startswith('silencedetect:'):
    return
  #print('SILENCE: ' + event['event']['text'])
  if eventText.find("silence_start") >= 0:
    print("SILENCE START:" + eventText)
  #elif eventText.find("silence_end") >= 0:
    print("SILENCE END:" + eventText)

player.af = 'lavfi=[silencedetect=n=-20dB:d=1]'
#player.command('no-osd af toggle lavfi=[volumedetect]') #Unknown command
#player.af = 'lavfi=[volumedetect]' #lavfi seems to recognize the filter

player.speed = 100 #100 is apparently the max, passing 101+ -> "TypeError: ('Tried to get/set mpv property using wrong format, or passed invalid value'..."

player.wait_for_playback()
