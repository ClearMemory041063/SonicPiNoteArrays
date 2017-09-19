#Example4.rb
#note shifting
###
##############
#define tempo and note lengths
tempo=1.0
whole=tempo
half=whole/2.0
dothalf=half*1.5
quart=half/2.0
dotquart=quart*1.5
eighth=quart/2.0
doteighth=eighth*1.5
#define the release fraction
rel=2.0 #0.8 #controls note release
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
###############
## a function to copy a one dimensional array
def array_copy(x)
  y=[]
  i=0
  while i<x.length
    y.push(x[i])
    i+=1
  end
  return y
end
###############
### Copying a 2D array
def array_copy2D(x)
  y=[]
  i=0
  while i<x.length
    y.push(array_copy(x[i]))
    i+=1
  end
  return y
end
###############
def shiftit(s,interval)
  rval= array_copy2D(s)
  i=0
  while i < s.length
    a=note(rval[i][0]+interval)
    b=midi2note(a)
    rval[i][0]=b
    i+=1
  end
  return rval
end
#end
###############
def revtime(s)
  rval= array_copy2D(s)
  rt=[]
  i=0
  while i < s.length
    rt.push(rval[i][1])
    i+=1
  end
  rt=rt.reverse
  i=0
  while i < s.length
    rval[i][1]=rt[i]
    i+=1
  end
  return rval
end
#end
###############
define :playit do|nte|
  puts nte[0],nte[1]
  if nte[0]!=:r
    play(nte[0],release:nte[1]*rel)
  end
  sleep nte[1]
end
###############
def playitt(tune)
  i=0
  while i<tune.length
    playit tune[i]
    i+=1
  end
end
########### end helper functions
#define some musical intervals
unison=0
octave=12
majorThird=4
perfectFourth=5
perfectFifth=7
##
# Put them in an array
interval=[unison,octave,majorThird,perfectFourth,perfectFifth]
###################


## define musical themes
theme1=[
  [:C4,quart],
  [:D4,quart],
  [:E4,quart],
  [:C4,quart],
  [:E4,quart],
  [:D4,eighth],
  [:C4,eighth],
  [:D4,quart],
  [:G4,quart],
  #]
  #theme2=[
  [:C4,quart],
  [:D4,quart],
  [:E4,quart],
  [:C4,quart],
  [:E4,quart],
  [:D4,eighth],
  [:C4,eighth],
  [:D4,quart],
  [:G3,quart],
]

#theme1r=theme1.reverse
#theme2r=theme2.reverse
#playitt(theme1r)
#playitt(theme1.reverse) # a neat trick to save memory
#playitt(theme2r)
# or
#theme1oct=shiftit(theme1,-octave)
#theme1fifth=shiftit(theme1,perfectFifth)

use_synth :fm
playitt(theme1)
playitt(theme1.reverse)
playitt(shiftit(theme1,-octave))     # down an octave
playitt(shiftit(theme1,perfectFifth)) # a neat trick to save memory
playitt(revtime(theme1))
playitt(revtime(theme1).reverse)



