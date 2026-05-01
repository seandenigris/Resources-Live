#Kill w ctrl-c

import os
import mpvsilence

file_path = os.path.dirname(os.path.realpath(__file__))

print(mpvsilence.version())

import mpv

player = mpv.MPV(loglevel='v')

player.play(file_path + "/sample_w_silence.m4a")

player.skip_silence()
player.skip_silence()
player.wait_for_playback()
