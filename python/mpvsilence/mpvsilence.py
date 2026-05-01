# Extends python-mpv's MPV class. References: 
#   - project: https://github.com/jaseg/python-mpv
#   - MPV class: https://github.com/jaseg/python-mpv/blob/0cda09c62872542b4b8427aaaa9600b8fd8d7d2f/mpv.py#L793
# Adapted from https://gist.github.com/bitingsock/e8a56446ad9c1ed92d872aeb38edf124 via lots of experimentation
# There is also this interesting approach: https://github.com/idMysteries/mpv-skip-silence/blob/main/autoeditor.js
import mpv

def version():
   return "0.1.4"

## Add a method to MPV
## Technique adapted from https://stackoverflow.com/a/2982
# Define method
def skip_silence(self, noise=-40, duration=1):
    self.set_loglevel('v')
    endPosition = None
    def is_silence_end(evt):
        nonlocal endPosition
        toks = evt['event']['text'].split()
        if 'silence_start:' in toks:
          self.speed = 100
        elif 'silence_end:' in toks:
          endPosition = float(toks[2])
          return True
        return False
    with self.prepare_and_wait_for_event('log_message', cond=is_silence_end):
      self.af = 'lavfi=[silencedetect=n=' + str(noise) + 'dB:d=' + str(duration) + ']'
    self.time_pos = endPosition
    self.speed = 1
    self.af = ''

# Install method
mpv.MPV.skip_silence = skip_silence
