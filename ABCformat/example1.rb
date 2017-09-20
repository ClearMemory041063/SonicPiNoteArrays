#Example1.rb
# 19 Sep 2017
# writing toABC file
Filepath= "C:/Users/jj/Documents/soundPi/SonicPiNoteArrays/ABC/"
Filename = "test1ABC.abc"
#define tempo and note lengths
tempo=1.0
whole=tempo          # for playittt set whole = tempo
whole=1.0            # for converison to ABC file set whole=1.0
half=whole/2.0
dothalf=half*1.5
quart=half/2.0
dotquart=quart*1.5
eighth=quart/2.0
doteighth=eighth*1.5
###############
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

test1=[
  [:A4,quart],
  [:Ab4,quart],
  [:As4,quart],
  [:A0,quart],
  [:As1,quart],
  [:Ab2,quart],
  [:As3,quart],
  [:Ab4,quart],
  [:As5,quart],
  [:Ab6,quart],
  [:As7,quart],
  [:A8,quart],
  [:Ab4,1.5*whole],
  [:As4,0.75*whole],
]
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
  [:C4,quart],
  [:D4,quart],
  [:E4,quart],
  [:C4,quart],
  [:E4,quart],
  [:D4,eighth],
  [:C4,eighth],
  [:D4,quart], # to test rest comment this line
  #[:r,quart],  # and uncomment this line
  [:G3,quart],
]
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
  #ABCitt(test1,f)
  #end of file writing
}



