#Harmony1.rb
# 21 Sep 2017
# Using scale intervals to produce harmony
# Contrasts with using half-tone or chromatic intervals
###################
# Things to try
# Try changing the scale from C4
# Try changing the interval variable
# Try a minor scale
#
interval=2
amplitude= 0.3
use_synth :fm
scal=scale :C, :major
#scal=scale :C, :minor

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
##########################################################

scal1=midi2noteList(scal)
#listit(scal1)

# extend the scale to two octaves
scal2=[]
i=0
while i<scal.length
  scal2.push(scal[i])
  i+=1
end

i=1
while i<scal.length
  scal2.push(scal[i]+12)
  i+=1
end
scal3=midi2noteList(scal2)
listit(scal3)

### play a scale with a 2nd note at an interval
with_fx :level, amp: amplitude do
  i=0
  while i<8
    play(scal2[i])
    play(scal2[i+interval])
    sleep 0.25
    i+=1
  end
end
