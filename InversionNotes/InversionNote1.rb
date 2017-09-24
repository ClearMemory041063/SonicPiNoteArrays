# inversionNote1.rb
# 24 sep 2017
##### things to twiddle
interval=2
amplitude= 0.3
use_synth :fm
#use_synth :beep
key = :C5
mode= :major
#mode= :augmented
#mode= :augmented2
#mode= :diminished
#puts scale_names
nle=[0.25,0.125,0.125] # note length
rel= 1.5 # note release
#####################################
nle=nle.ring
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

def midi2note(n)
  nn= note_info(n)
  #  puts nn
  nnn=nn.to_s.split(":")
  #  puts nnn
  mmm= nnn[3].chop
  return mmm
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
  #  puts tone,scal,n
  xxx=getScaleIndex(tone,keyscale)
  puts "XXX=",xxx
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
  #  puts "Tone index=",toneindex
  #  puts "Ref index=",refindex
  d=refindex[0]-toneindex[0]
  octshift=refindex[1]-toneindex[1]
  e=refindex[2]-toneindex[2]
  retval=gScaleI2(ref,keyscale,d,octshift,e)
  retval=midi2note(retval)
  return retval
end # invertNote
###########################
## Tests for shiftOnScale
#############
## Test1 runs all 12 major scales with notes from the scale in octave 4
define :test1 do |amplitude|
  start = 60
  size=12
  stop=start+size
  ### play a tune with a 2nd note at an interval
  with_fx :level, amp: amplitude do
    i=start
    while i<stop
      scal1=scale i, :major
      puts "Scale=",i,midi2note(i)
      listit(midi2noteList(scal1))
      j=0
      while j< scal1.length
        nn=shiftOnScale(scal1[j],scal1,interval)
        puts midi2note(scal1[j]),midi2note(nn)
        play(scal1[j])
        play(nn)
        sleep 0.25
        j+=1
      end
      i+=1
    end
  end
end #test1
#############


##################################################################
## New Stuff
##################
define :tune1 do |amplitude|
  puts "Test 7"
  keyscale=scale key, mode
  ks=array_copy(keyscale)
  puts keyscale
  with_fx :level, amp: amplitude do
    m=0
    while m<2
      k=0
      while k<ks.length
        j=0
        while j<ks.length
          i=k
          while i < ks.length
            puts midi2note(ks[i])
            invnote= invertNote(ks[j],ks[i],keyscale)
            puts invnote,midi2note(invnote)
            play(invnote,release: nle[i/3]*rel)
            play(ks[i],release: nle[i/3]*rel)
            sleep nle[i/3]
            i+=4
          end #next i
          j+=1
        end #next j
        k+=1
      end #next k
      ks=ks.reverse
      m+=1
    end #next m
  end #with_fx
end #tune1

tune1 0.25
mode= :augmented
tune1 0.25
mode= :diminished
tune1 0.25
mode= :minor
tune1 0.25