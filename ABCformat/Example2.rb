# Example2.rb in ABCformat directory
# 20 Sep 2017
#Derived from Example4.rb in shifting directory
# and from Example1.rb in ABCformat directory
#note shifting
###
# writing toABC file
Filepath= "C:/Users/jj/Documents/soundPi/SonicPiNoteArrays/ABC/"
Filename = "Example2.abc"
#define tempo and note lengths
tempo=1.0
whole=tempo          # for playittt set whole = tempo
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

#use_synth :fm
#playitt(theme1)
#playitt(theme1.reverse)
#playitt(shiftit(theme1,-octave))     # down an octave
#playitt(shiftit(theme1,perfectFifth)) # a neat trick to save memory
#playitt(revtime(theme1))
#playitt(revtime(theme1).reverse)

header=[
  "X: 1",
  "T: "+Filename,
  "C: Joe",
  "M: 4/4",
  "L: 1/1",
  "Q: 1/4=140",
  "K: C",
]

# open the file
# open and write to a file with ruby
open(Filepath+Filename, 'w') { |f|
  #f.puts "Hello, world."
  #}
  #write the header to the file
  i=0
  while i<header.length
    f.puts header[i]+"\n"
    i+=1
  end
  # write the music for one voice in ABC format to the file
  ABCitt(theme1,f)
  ABCitt(theme1.reverse,f)
  ABCitt(shiftit(theme1,-octave),f)     # down an octave
  ABCitt(shiftit(theme1,perfectFifth),f) # a neat trick to save memory
  ABCitt(revtime(theme1),f)
  ABCitt(revtime(theme1).reverse,f)
  #end of file writing
}

