Shifting ReadMe.md
#### Shifting Notes by Musical intervals

[Return to main page]( )


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
#### Applying Musical Intervals to 2D Arrays
Under Construction