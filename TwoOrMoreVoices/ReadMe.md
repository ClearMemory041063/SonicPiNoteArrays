Two or more voices ReadMe.md
#### Two or More Voices

[Return to main page]( https://github.com/ClearMemory041063/SonicPiNoteArrays)

#### The Example1.rb Program

##### Configuration

A flag variable run_mode switches the program between playing the music and producing an ABC notation file.
If the ABC notation option is selected the variables Filepath and Filname select where the data will be written


```
### select program function
run_mode =0 #play music
#run_mode =1 #write ABC file
### setup path and filename
# writing toABC file
Filepath= "C:/Users/jj/Documents/soundPi/SonicPiNoteArrays/TwoOrMoreVoices/"
Filename = "Example1.abc"
```
##### Bug Fix to playit function
 
Decouple the tempo from the list of note lengths.
Change test for a rest note from :R to "R"


```
define :playit do|nte|
  puts nte[0],nte[1]
  a=tempo*nte[1]              #### insert tempo here
  puts "RRR=",nte[0]
  if nte[0]!= "R"             ##### Had to change this from :R
    play(nte[0],release:a*rel)
  end
  sleep a
end
```

##### Added Funtion to Create a 2D Array That Retains the Note Timngs, But Replaces the Notes With Rests

```
def insertRest(s)
  rval= array_copy2D(s)
  i=0
  while i < s.length
    rval[i][0]="R"
    i+=1
  end
  return rval
end
```
##### Use Two Live_loops to Play the Music 


```
if run_mode <1 #play the tune
  use_synth :fm
  live_loop :LL1 do
    playitt(theme1)
    playitt(insertRest(theme1))
    playitt(theme1)
  end
  
  live_loop :LL2 do
    sync :LL1
    playitt(insertRest(theme1))
    playitt(shiftit(theme1,perfectFifth))
    playitt(shiftit(theme1,perfectFifth))
  end
  
else  #write the ABC music file
```
##### Write the ABC Notation in Two Parts

Write the header.

Write "V:1\n" to indicate the first part.

Write the first part.

Write "V:2\n" to indicate the second part.

Write the second part.


```
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
    ABCitt(shiftit(theme1,perfectFifth),f) # a neat trick to save memory
    ABCitt(shiftit(theme1,perfectFifth),f) # a neat trick to save memory
    #end of file writing
  }
```
##### What You Will Hear
The sheet music is in the Example1.pdf
the software runABC was used to create it from the Example1.abc file.

Live_loop1 plays the theme while live_loop2 rests.

Live_loop2 plays the theme shifted up by a perfect fifth interval, while live_loop1 rests.

Finally live_loop1 plays the theme while live_loop2 plays the shifted theme. 

Not a harmonic combination! Same tune played in two different keys.

