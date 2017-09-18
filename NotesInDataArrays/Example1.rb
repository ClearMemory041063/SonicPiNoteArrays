#Example1.rb
use_synth :fm
play(:C4)
sleep 0.5
play(:D4)
sleep 0.25
play(:E4)
sleep 0.5

use_synth :fm
# use MIDI notes
play_pattern_timed [60, 62, 64,], [0.5,0.25,0.5]
# or use Letter notes
play_pattern_timed [:C4,:D4,:E4], [0.5,0.25,0.5]

use_synth :fm
##############
#define tempo and note lengths
tempo=4.0
whole=tempo
half=whole/2.0
dothalf=half*1.5
quart=half/2.0
dotquart=quart*1.5
eighth=quart/2.0
doteighth=eighth*1.5
#define the release fraction
rel=0.8
###############
define :playit do|nte|
  puts nte[0],nte[1]
  if nte[0]!=:r
    play(nte[0],release:nte[1]*rel)
  end
  sleep nte[1]
end
#################
playit [:C4,quart]
playit [:D4,eighth]
playit [:E4,eighth]
########
tune=[
  [:C4,quart],
  [:D4,eighth],
  [:E4,eighth],
  [:C4,quart],
  [:E4,eighth],
]
i=0
while i<tune.length
  playit tune[i]
  i+=1
end
