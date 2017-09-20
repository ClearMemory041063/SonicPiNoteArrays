ABC Format ReadMe.md
#### Exporting to an ABC Format File to Obtain Sheet Music

[Return to main page]( https://github.com/ClearMemory041063/SonicPiNoteArrays)

#### ABC Music Notation

[ABCplus]( http://natura.di.uminho.pt/~jj/ipm/abcplus_en.pdf)

[ABC Tutorial]( http://www.lesession.co.uk/abc/abc_notation.htm)

#### Software That Reads ABC Notation and Prints Sheet Music

[Wikipedia Article]( https://en.wikipedia.org/wiki/ABC_notation)

[The ABC Music project]( http://abc.sourceforge.net/)

#### Translation of Musical Theme in 2D Array to a File in ABC Notation

The program, Example1.rb creates/ writes or overwrites to a file specified by the variables Filename and Filepath in the program.
In the path "\" doesn't work, substitute "/".
As written the Filename="test1ABC.abc" 

The file test1.abc contains the ABC notation, and can be viewed by using a text editor such as notepad.

The runABC was used to open test1ABC.abc, play the theme as a MIDI, and view the sheet music.

A supplimental program named GSview to open the out.ps file in the runABC home dorectory. GS view allows the postscript file out.ps to be saved as a PDF file. Open the test1ABC.pdf with a pdf viewer and print the sheet music if you want. The GSView is referenced in the ABC Music Project.

#### The 2D Theme Array

```
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
```

#### Translating the Notation

```
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
```

#### Listing of Test1ABC.abc

```
X: 1
T: test1ABC.abc
C: Joe
M: 4/4
L: 1/1
Q: 1/4=140
K: C
C/4 D/4 E/4 C/4 |E/4 D/8 C/8 D/4 G/4 |
C/4 D/4 E/4 C/4 |E/4 D/8 C/8 D/4 G,/4 |
```

#### Example2.rb
This is a merger of Example1.rb from above
and Example4.rb in the Shifting directory.
The output is in Example2.abc, and the sheet musing is in the Example2.pdf

This shows the various tranformations of the musical theme that were performed by Example4.rb.

These were:

```
#use_synth :fm
#playitt(theme1)
#playitt(theme1.reverse)
#playitt(shiftit(theme1,-octave))     # down an octave
#playitt(shiftit(theme1,perfectFifth)) # a neat trick to save memory
#playitt(revtime(theme1))
#playitt(revtime(theme1).reverse)

  # write the music for one voice in ABC format to the file
  ABCitt(theme1,f)
  ABCitt(theme1.reverse,f)
  ABCitt(shiftit(theme1,-octave),f)     # down an octave
  ABCitt(shiftit(theme1,perfectFifth),f) # a neat trick to save memory
  ABCitt(revtime(theme1),f)
  ABCitt(revtime(theme1).reverse,f)
  #end of file writing

