Shifting ReadMe.md
#### Shifting Notes by Musical intervals

[Return to main page](https://github.com/ClearMemory041063/SonicPiNoteArrays )


#### Musical Intervals

An ocatave shifts the frequency of a note by 2.0
A half tone shifts the frequency of a note by exp(ln(2.0)/12.0)= 1.05946 = 2.0^(-12.0)
The notes A3 and C4 are a half tone interval apart as are the note E4 to F4
The interval between note C4 to Bb4 is a half tone, white key to black key on the piano.
The interval between C4 and D4 is a whole interval as there is a black key in between.

[Intervals Wikipedia]( https://en.wikipedia.org/wiki/Interval_(music))

#### Using MIDI note numbers to shift a note

See example1.rb

Example2.rb uses the reversal property of the ring structure to permutate arpeggios on a scale.


```
#Example2.rb
#note shifting
###
## Helper functions
def midi2note(n)
  nn= note_info(n)
  #  puts nn
  nnn=nn.to_s.split(":")
  #  puts nnn
  mmm= nnn[3].chop
  return mmm
end
###########
#define some musical intervals
unison=0
octave=12
majorThird=4
perfectFourth=5
perfectFifth=7
##
# Put them in an array
interval=[unison,octave,majorThird,perfectFourth,perfectFifth]

use_synth :fm

s=scale :C, :major #minor
puts s

def tune1(s,interval)
  i=0
  while i < s.length
    j=0
    while j < interval.length
      a=note(s[i]+interval[j])
      puts a,midi2note(a)
      play(a)
      sleep 0.25
      j+=1
    end
    i+=1
  end
end

tune1(s,interval) #t1 i1
s=s.reverse
tune1(s,interval) #t2 i1
interval=interval.reverse
tune1(s,interval) #t2 i2
s=s.reverse
tune1(s,interval) #t1 i2
interval=interval.reverse
tune1(s,interval) #t1 i1
```
#### Functione to Modify a Musical Theme Contained in a 2D Array
Example4.rb contains the code for a 2D array containing the musical theme.
The function playitt is use to play the tones and timings in the theme1 array.
First define some note duration values

```
#define tempo and note lengths
tempo=1.0
whole=tempo
half=whole/2.0
dothalf=half*1.5
quart=half/2.0
dotquart=quart*1.5
eighth=quart/2.0
doteighth=eighth*1.5
#define the release fraction
rel=2.0 #0.8 #controls note release
```
Setup the musical theme in a 2D array

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
  [:D4,quart],
  [:G3,quart],
]
```

Play theme1 followed by variations on theme1.

```
use_synth :fm
playitt(theme1)
playitt(theme1.reverse)
playitt(shiftit(theme1,-octave))     # down an octave
playitt(shiftit(theme1,perfectFifth)) # a neat trick to save memory
playitt(revtime(theme1))
playitt(revtime(theme1).reverse)
```
You can create new arrays using these functions or use them as the argument to the playitt function.
For instance:
themex=theme1.reverse
playitt(themex)
or
playitt(theme1.reverse)

theme1.reverse plays the theme backwards.
shiftit(theme1,-octave) shift the tone by the interval -octave.
Some shift values are defined in the code.

```
#define some musical intervals
unison=0
octave=12
majorThird=4
perfectFourth=5
perfectFifth=7
```

revtime(theme1) reverses the note duration timing.
You can stack the functions as in:
playitt(revtime(theme1).reverse)

