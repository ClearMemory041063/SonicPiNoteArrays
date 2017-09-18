#Example1.rb
#note shifting

octave=12
majorThird=4
perfectFourth=5
perfectFifth=7

use_synth :fm
play(:C4)
sleep 0.5

a=note(:C4)
puts a
b=a+octave
puts b
play(b)
sleep 0.5

c= a+majorThird
puts c
play(c)
sleep 0.5

d= a+perfectFourth
puts d
play(d)
sleep 0.5

e= a+perfectFifth
puts e
play(e)
sleep 0.5