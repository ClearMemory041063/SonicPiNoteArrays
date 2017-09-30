#testHI2D.rb
# 30 Sep 2017
# Test of HI and HI2D modules
# To remove the modules exit and restart Sonic Pi
##############
#Define tempo and note lengths and release fraction
#####
tempo=1.0
#define note timings
whole=1.0
half=whole/2.0
dothalf=half*1.5
quart=half/2.0
dotquart=quart*1.5
eighth=quart/2.0
doteighth=eighth*1.5
#define the release fraction
rel=2.0 #0.8 #controls note release
################################################
transp = 5 # use this to transpose the key by integer halftones on chromatic scale
# Helper functions
###############
define :playit do|nte|
  b=note(nte[0])
  if b != nil
    b+=transp
  end
  b=HI.midi2note(b)
  puts transp,nte[0],b,nte[1]
  a=tempo*nte[1]
  play(b,release:a*rel)
  sleep a
end

###############
def playitt(tune)
  i=0
  while i<tune.length
    playit tune[i]
    i+=1
  end
end
########### end helper function
# Load and link the two modules
if (defined? HI) == nil
  puts "HI is nil"
  require "C:/MySPmodules/HI.rb"
  HI.link(self)
else
  puts "HI Exists"
end
if (defined? HI2D) == nil
  puts "HI2D is nil"
  require "C:/MySPmodules/HI2D.rb"
  HI2D.link(self,HI)
else
  puts "HI2D Exists"
end
###################
keyscale=scale :C4, :major # used by harmony portion
transpose =0
## define musical themes
theme1=[
  [:C4,quart],
  # [:r,whole],
  [:D4,quart],
  [:E4,quart],
  [:C4,quart],
  [:E4,quart],
  [:D4,eighth],
  [:C4,eighth],
  [:D4,quart],
  [:G4,quart],
  [:C4,quart],
  [:D4,quart],
  [:E4,quart],
  [:C4,quart],
  [:E4,quart],
  [:D4,eighth],
  [:C4,eighth],
  [:D4,quart],
  [:G3,quart],
] # end theme1
theme2=[
  [:C4,half],
  [:C4,half],
  [:C4,whole],
] #end theme2
i=0
use_synth :fm
live_loop :LL1 do
  with_fx :level, amp: 0.3 do
    puts "SSSSSSSSSSSSSSSSSSS",i
    playitt(theme1)
    playitt(theme1)
    playitt(theme1)
    playitt(theme1)
    playitt(theme1)
    if i==1 then theme1=theme1.reverse end
    if i==2 then theme1=HI2D.revtime(theme1) end
    if i==3 then theme1=theme1.reverse end
    if i==4 then theme1=HI2D.revtime(theme1) end
    i+=1
    if i>4 # then i=0 end
      playitt(theme2)
      stop
    end
  end
end
live_loop :LL2 do
  sync :LL1
  with_fx :level, amp: 0.3 do
    playitt(HI2D.insertRest(theme1))
    playitt(HI2D.invert(theme1,:C4,keyscale))
    playitt(HI2D.invert(theme1,:C5,keyscale))
    playitt(HI2D.invert(theme1,:G5,keyscale))
    playitt(HI2D.harmonize(theme1,keyscale,2))
    if i>4 # then i=0 end
      playitt(theme2)
      stop
    end
  end
end



