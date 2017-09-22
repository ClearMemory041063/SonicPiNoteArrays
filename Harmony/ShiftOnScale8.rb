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
    rval.push [list[i], midi2note(list[i])]
    i+=1
  end
  return rval
end
##### The shifting function
def shiftOnScale(tone,scal,n)
  aoct=0
  octshift=0
  #  scal.pop #remove the last element of scale
  base=scal[0] # the MIDI number of the scale start
  a=note(tone) # is the MIDI number of the note to harmonize
  aa=note(tone)
  puts "a aa=",a,aa
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
  puts "b=",b
  #see if the adjusted note is in the scale
  e=0
  if scal.include?(b)
    puts "b in scal"
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
  puts "e=",e
  c=scal.index(b+e) # cis the index of the note
  puts "onote=",c,midi2note(scal[c])
  d=c+n-e # d is the index of the harmony note
  # is the d index too big if so adjust it
  if(d>6) #7
    puts "D>>"
    aoct=1 #flag it for later
    d=d-7
  end
  # is the d index negative
  if(d<0) #7
    puts "D<<"
    aoct=-1 #flag it for later
    d=d+7
  end
  
  puts "d=",d,scal[d],aoct
  d=scal[d]+aoct*12+octshift
  puts "DD",aa,d,aa-d
  if (d < aa)  && (n<0)
    puts "DDD",aa,d,aa-d
    while (aa-d) > 12
      puts "UP"
      d+=12
    end
  end
  puts d,midi2note(d)
  return midi2note(d)
end
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
      while j<scal1.length
        nn=shiftOnScale(scal1[j],scal1,interval)
        puts midi2note(scal1[j]),nn
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
        puts midi2note(keyscale[j]),nn
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
    keyscale=scale :C4, :major
    listit(midi2noteList(keyscale))
    j=0
    while j<keyscale.length
      nn=shiftOnScale(keyscale[j],keyscale,2)
      mm=shiftOnScale(keyscale[j],keyscale,5)
      puts midi2note(keyscale[j]),nn
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
        puts midi2note(scal1[j]),nn
        play(scal1[j])
        play(nn)
        sleep 0.25
        j+=1
      end
      i+=1
    end
  end
end #test4

test1 amplitude
test2 amplitude
test3 amplitude
test4 amplitude