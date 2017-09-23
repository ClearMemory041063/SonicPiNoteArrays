# InversionEx1.rb
# 23 Sep 2017
# Tests the new functions using harmony
#HarmonyEx2.rb
# 21 Sep2017
#2orMex1.rb
# Example1.rb in TwoOrMoreVoices directory
# 20 Sep 2017
#derived from example2.rb in ABC directory
#Derived from Example4.rb in shifting directory
# and from Example1.rb in ABCformat directory
#note shifting
##################################### CONFIGURATION
### select program function
run_mode =0 #play music
#run_mode =1 #write ABC file
### setup path and filename
# writing toABC file
Filepath= "C:/Users/jj/Documents/soundPi/SonicPiNoteArrays/inversion/"
Filename = "InversionEx1.abc"
#####################################
#define tempo and note lengths
tempo=1.0 # inserting tempo into playit
#whole=tempo          # for playittt set whole = tempo
whole=1.0            # for converison to ABC file set whole=1.0##############
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
###############
def insertRest(s)
  rval= array_copy2D(s)
  i=0
  while i < s.length
    rval[i][0]="R"
    i+=1
  end
  return rval
end

###############
define :playit do|nte|
  puts nte[0],nte[1]
  a=tempo*nte[1]
  if nte[0]!="R" #:r
    play(nte[0],release:a*rel)
  end
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
#### merge the ABC functions
def to2fraction(a)
  retv=[]
  b=a*256.0
  c=256.0
  while ((b/2.0)%2.0)==0.0
    b/=2.0
    c/=2.0
  end
  b/=2.0
  c/=2.0
  #  puts b.to_i.to_s+"/"+c.to_i.to_s
  retv.push(b.to_i)
  retv.push(c.to_i)
  return retv
end
###############
define :ABCit do|nte|
  #puts nte[0],nte[1]
  a=nte[0].to_s
  #puts a
  tone=a[0].upcase
  #puts tone
  sss=""
  if tone != "R"
    oct=a[a.length-1].to_i
    mod=""
    if a.length>2 then mod=a[1].downcase end
    #  puts tone,oct,mod #,a.length
    #    sss=""
    case mod
    when "b"
      sss+="_"
    when "s"
      sss+="^"
    else
    end
    if oct<5
      sss+=tone.upcase
    end
    if oct>4
      sss+=tone.downcase
    end
    case oct
    when 3
      sss+=","
    when 2
      sss+",,"
    when 1
      sss+=",,,"
    when 0
      sss+=",,,,"
    when 6
      sss+="'"
    when 7
      sss+="''"
    when 8
      sss+="'''"
    end
  else
    # puts "ZZZ"
    sss+="z"
  end
  #puts sss,nte[1],nte
  # process the timing
  c=to2fraction(nte[1]) #/tempo
  if c[0] !=1
    sss+=c[0].to_s
  end
  sss+="/"
  sss+=c[1].to_s
  return sss
end
###############
def ABCitt(tune,f)
  i=0
  sss=""
  mcount=0.0
  while i<tune.length
    sss+=ABCit tune[i]
    sss+=" "
    mcount+=tune[i][1]
    if mcount%1.0 !=0.0  #where to insert measure bars
    else
      sss+="|"
    end
    if mcount < 2.0 #measure per line
    else
      sss+="\n"
      puts sss
      f.puts sss
      sss=""
      mcount=0.0
    end
    i+=1
  end
  #  puts sss
end
### insert harmony and inversion functions
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

#############
def invert(s,ref,keyscale)
  rval= array_copy2D(s)
  i=0
  while i < s.length
    #rval[i][0]=shiftOnScale(rval[i][0],scal,n)
    rval[i][0]=invertNote(ref,rval[i][0],keyscale)
    i+=1
  end
  return rval
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
keyscale=scale :C4, :major # used by harmony portion

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

if run_mode <1 #play the tune
  use_synth :fm
  live_loop :LL1 do
    with_fx :level, amp: 0.3 do
      playitt(theme1)
      playitt(insertRest(theme1))
      playitt(theme1)
    end
  end
  live_loop :LL2 do
    sync :LL1
    with_fx :level, amp: 0.3 do
      playitt(insertRest(theme1))
      playitt(harmonize(theme1,keyscale,2))
      playitt(harmonize(theme1,keyscale,2))
    end
  end
else  #write the ABC music file
  header=[
    "X: 1",
    "T: "+Filename,
    "C: Joe",
    "M: 4/4",
    "L: 1/1",
    "Q: 1/4=200",
    "K: C",
  ]
  
  # open the file
  # open and write to a file with ruby
  open(Filepath+Filename, 'w') { |f|
    #write the header to the file
    i=0
    while i<header.length
      f.puts header[i]+"\n"
      i+=1
    end
    # write the music for one voice in ABC format to the file
    f.puts "V:1\n"
    ABCitt(theme1,f)
    ABCitt(insertRest(theme1),f)
    ABCitt(theme1,f)
    f.puts "V:2\n"
    ABCitt(insertRest(theme1),f)
    ABCitt(harmonize(theme1,keyscale,2),f)
    ABCitt(harmonize(theme1,keyscale,2),f)
    #    ABCitt(shiftit(theme1,perfectFifth),f) # a neat trick to save memory
    #    ABCitt(shiftit(theme1,perfectFifth),f) # a neat trick to save memory
    #end of file writing
  }
end
