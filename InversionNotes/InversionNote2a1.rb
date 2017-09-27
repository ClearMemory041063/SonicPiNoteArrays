# inversionNote2a1.rb
# 26 Sep 2017
# fix :r problem
# 24 sep 2017
## Helper functions
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

def midi2note(n)
  nn=note(n)
  if nn==nil
    #    puts "nil seen",nn
    return nn
  else
    nn= note_info(nn)
    #    puts nn
    nnn=nn.to_s.split(":")
    #  puts nnn
    mmm= nnn[3].chop
    return mmm
  end
end # midi2note
#####
def listit(list)
  i=0
  while i<list.length
    puts i,list[i]
    i+=1
  end
end # listit
#####
def midi2noteList(list)
  rval=[]
  i=0
  while i<list.length
    rval.push [list[i], midi2note(list[i])]
    i+=1
  end
  return rval
end #midi2noteList
##### Starting function for shiftOnScale and invertNote
##### gets the index of a note in a scale
def getScaleIndex(tone,scal)
  #  puts tone,scal
  aoct=0
  octshift=0
  #  scal.pop #remove the last element of scale
  base=scal[0] # the MIDI number of the scale start
  a=note(tone) # is the MIDI number of the note to harmonize
  #  puts "note(tone)=",a
  if a==nil then return a end
  #  aa=note(tone)
  # puts "a aa=",a,aa
  #adjust the value to fall in the range of the scale
  while a<base # note is lower
    a+=12
    octshift-=12
  end
  while a>(base+12) # note is higher
    a-=12
    octshift+=12
  end
  b=a
  # puts "b=",b
  #see if the adjusted note is in the scale
  e=0
  if scal.include?(b)
    #    puts "b in scal"
    e=0
  else
    if scal.include?(b+1)
      e=1
    else
      if scal.include?(b-1)
        e=-1
      else
        return :C7 #signal an error
      end
    end
  end
  #  puts "e=",e
  c=scal.index(b+e) # cis the index of the note
  #  puts "onote=",c,midi2note(scal[c])
  #  puts "z",c,octshift,e
  retval=[c,octshift,e]
  #  puts retval
  return retval
end # getScaleIndex
##### Finishing function for shiftOnScale and invertNote
def gScaleI2(ref,keyscale,d,octshift,e)
  aoct=0
  n=d
  #  octshift=refindex[1]-toneindex[1]
  #  e=refindex[2]-toneindex[2]
  aa=note(ref)
  while d>6
    #    puts "D>>"
    aoct=1 #flag it for later
    d=d-7
  end
  while d<0
    #    puts "D<<"
    aoct=-1 #flag it for later
    d=d+7
  end
  #puts "d=",d,keyscale[d],aoct
  d=keyscale[d]+aoct*12+octshift
  #  puts "DD",aa,d,aa-d
  if (d < aa)  && (n<0)
    #   puts "DDD",aa,d,aa-d
    while (aa-d) > 12
      #     puts "UP"
      d+=12
    end
  end
  #  puts d,midi2note(d)
  return d
end # gScaleI2
##### The shifting function
def shiftOnScale(tone,keyscale,n)
  #  puts tone,keyscale,n
  xxx=getScaleIndex(tone,keyscale)
  #  puts "XXX=",xxx
  if xxx==nil then return :r end
  d=xxx[0]+n
  octshift=xxx[1]
  e=xxx[2]
  retval=gScaleI2(tone,keyscale,d,octshift,e)
  retval=midi2note(retval)
  return retval
end # shiftOnScale
##### The inversion function
def invertNote(ref,tone,keyscale)
  #  puts "IN",ref,tone
  refindex=getScaleIndex(ref,keyscale)
  toneindex=getScaleIndex(tone,keyscale)
  puts "Tone index=",toneindex
  puts "Ref index=",refindex
  if toneindex==nil then return :r end
  if refindex==nil then return :r end
  d=refindex[0]-toneindex[0]
  octshift=refindex[1]-toneindex[1]
  e=refindex[2]-toneindex[2]
  retval=gScaleI2(ref,keyscale,d,octshift,e)
  retval=midi2note(retval)
  return retval
end # invertNote
##################################################################
## New Stuff
##################
##### things to twiddle
interval=2
amplitude= 0.3
use_synth :fm
#use_synth :beep
key = :C5
mode= :major
#mode= :minor
#mode= :augmented
#mode= :augmented2
#mode= :diminished
#puts scale_names
nle=[0.25,0.125,0.125,0.5] # note lengths
#nle=[0.25,0.25,0.125,0.25] # note lengths
rel= 1.5 # note release
#####################################
nle=nle.ring
define :tune2 do |amplitude|
  keyscale=scale key, mode
  ref= note keyscale[0]
  ref=ref-12
  ks=array_copy(keyscale)
  ks1= ks.slice(0,4)+(ks.slice(4,7)).reverse
  puts keyscale
  puts ks
  puts ks1
  with_fx :level, amp: amplitude do
    k=0
    while k<3
      j=0
      while j<4
        i=0
        while i<ks1.length
          v1=shiftOnScale(ks1[i],keyscale,j)
          v2=shiftOnScale(v1,keyscale,-5)
          v3=invertNote(ref,v1,keyscale)
          play(v1,release: nle[i]*rel)
          if(k>0)then play(v2,release: nle[i]*rel) end
          if(k==2)then play(v3,release: nle[i]*rel) end
          sleep nle[i]
          i+=1
        end
        j+=1
      end
      j=3
      while j>0
        i=0
        while i<ks1.length
          v1=shiftOnScale(ks1.reverse[i],keyscale,j)
          v2=shiftOnScale(v1,keyscale,-5)
          v3=invertNote(ref,v1,keyscale)
          play(v1,release: nle[i]*rel)
          if(k>0)then play(v2,release: nle[i]*rel) end
          if(k==2)then play(v3,release: nle[i]*rel) end
          sleep nle[i]
          i+=1
        end #next i
        j-=1
      end #next j
      puts keyscale
      play(76,release: 0.25*rel)
      sleep 0.25
      play(72,release: 0.25*rel)
      sleep 0.25
      k+=1
    end #next k
    i=0
    et=[0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.5]
    while i<keyscale.length
      play(keyscale[i],release: et[i]*rel)
      sleep et[i]
      i+=1
    end
    
  end # with_fx
end #tune2

mode= :major
tune2 0.25

puts note :C4
puts :r
puts note :r
