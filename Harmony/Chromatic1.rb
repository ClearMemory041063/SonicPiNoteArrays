#Chromatic1.rb
# 21 Sep 2017
# Using chromatic intervals to produce dissonance
# Contrasts scale intervals with half-tone or chromatic intervals
###################
# Things to try
# Try changing the scale from C4
# Try changing the interval variable
# Try a minor scale
#
interval=4
amplitude= 0.3
use_synth :fm
scal=scale :C, :major
#scal=scale :C, :minor
#################
#define some musical intervals
unison=0
octave=12
majorThird=4
perfectFourth=5
perfectFifth=7
######################
####################
## Helper functions
def midi2note(n)
  nn= note_info(n)
  #  puts nn
  nnn=nn.to_s.split(":")
  #  puts nnn
  mmm= nnn[3].chop
  return mmm
end
def listit(list)
  i=0
  while i<list.length
    puts i,list[i]
    i+=1
  end
end
def midi2noteList(list)
  rval=[]
  i=0
  while i<list.length
    rval.push midi2note(list[i])
    i+=1
  end
  return rval
end
##########################################################1=midi2noteList(scal)
scal1=midi2noteList(scal)
listit(scal1)

### play a scale with a 2nd note at an interval
with_fx :level, amp: amplitude do
  i=0
  while i<8
    play(scal[i])
    play(scal[i]+interval)
    sleep 0.25
    i+=1
  end
end
