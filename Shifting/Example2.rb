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