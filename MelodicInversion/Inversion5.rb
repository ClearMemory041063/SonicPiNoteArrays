# inversion5.rb
# 23 sep 2017

#shiftOnScale8.rb
# 21 Sep 2017
#
##### things to twiddle
interval=2
amplitude= 0.3
use_synth :fm


#####################################

## Helper functions
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
## Test2 runs all 12 major scales with notes from the scale in lower octave
define :test2 do |amplitude|
  start = 60
  size=12
  stop=start+size
  ### play a tune with a 2nd note at an interval
  with_fx :level, amp: amplitude do
    i=start
    while i<stop
      keyscale=scale i, :major
      puts "Scale=",i,midi2note(i)
      listit(midi2noteList(keyscale))
      j=0
      while j<keyscale.length
        nn=shiftOnScale(keyscale[j]-12,keyscale,interval)
        puts midi2note(keyscale[j]),midi2note(nn)
        play(keyscale[j])
        play(nn)
        sleep 0.25
        j+=1
      end
      i+=1
    end
  end
end #test2

## Test3 runs a major scales to produce chords
define :test3 do |amplitude|
  with_fx :level, amp: amplitude do
    keyscale=scale :c4, :major
    listit(midi2noteList(keyscale))
    j=0
    while j<keyscale.length
      nn=shiftOnScale(keyscale[j],keyscale,2)
      mm=shiftOnScale(keyscale[j],keyscale,5)
      puts midi2note(keyscale[j]),midi2note(nn),midi2note(mm)
      play(keyscale[j])
      play(nn)
      play(mm)
      sleep 0.5
      j+=1
    end
  end
end #test3
## Test4 runs all 12 major scales with notes from the scale in octave 4
## but uses a negative interval
define :test4 do |amplitude|
  start = 60
  size=1
  stop=start+size
  ### play a tune with a 2nd note at an interval
  with_fx :level, amp: amplitude do
    i=start
    while i<stop
      scal1=scale i, :major
      puts "Scale=",i,midi2note(i)
      listit(midi2noteList(scal1))
      j=0
      while j<scal1.length
        nn=shiftOnScale(scal1[j],scal1,-interval)
        puts midi2note(scal1[j]),midi2note(nn)
        play(scal1[j])
        play(nn)
        sleep 0.25
        j+=1
      end
      i+=1
    end
  end
end #test4

###########################
## Tests for getScaleIndex
## Test5 test the getScaleIndex function
define :test5 do |amplitude|
  puts "Test 5"
  keyscale=scale :C4, :major
  puts keyscale
  i=keyscale[0]
  while i < (keyscale.length+12+keyscale[0])
    puts i,midi2note(i)
    puts getScaleIndex(i,keyscale)
    #  retval=[c,octshift,e] scaleindex,octshift,sharp_flat_adjust
    i+=1
  end
  
  
  with_fx :level, amp: amplitude do
  end
end

define :test6 do |amplitude|
  puts "Test 6"
  keyscale=scale :C5, :major
  puts keyscale
  with_fx :level, amp: amplitude do
    i=keyscale[0]
    while i < (keyscale.length+8+keyscale[0])
      puts i,midi2note(i)
      invnote= invertNote(keyscale[0],i,keyscale)
      puts invnote,midi2note(invnote)
      play(invnote)
      play(i)
      sleep 0.25
      i+=1
    end
  end
end #test6

define :test7 do |amplitude|
  puts "Test 7"
  keyscale=scale :C5, :major
  puts keyscale
  with_fx :level, amp: amplitude do
    i=0
    while i < keyscale.length
      puts keyscale[i],midi2note(keyscale[i])
      invnote= invertNote(keyscale[0],keyscale[i],keyscale)
      puts invnote,midi2note(invnote)
      play(invnote)
      play(keyscale[i])
      sleep 0.25
      i+=1
    end
  end
end #test7


###
## Tests for shiftOnScale
test1 amplitude
test2 amplitude
test3 amplitude
test4 amplitude

## Tests for getScaleIndex
test5 0.25

## Test for inversion
test6 0.25
test7 0.25

