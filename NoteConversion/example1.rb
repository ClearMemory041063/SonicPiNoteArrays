#Example1.rb
# Note conversion
# Letter note
play(:C4)
sleep 0.25

# note in string
x="D4"
play(x.intern)
sleep 0.25

y=note(x)
puts "y=",y
#+- "y=" 62
z=note(:C4)
puts "z=",z
# +- "z=" 60


## letter note from MIDI note
def midi2note(n)
  nn= note_info(n)
  #  puts nn
  nnn=nn.to_s.split(":")
  #  puts nnn
  mmm= nnn[3].chop
  return mmm
end

i=60
while i<72
  puts i,midi2note(i)
  i+=1
end
# Produces
# +- 60 "C4"
# +- 61 "Cs4"
# +- 62 "D4"
# +- 63 "Eb4"
# +- 64 "E4"
# +- 65 "F4"
# +- 66 "Fs4"
# +- 67 "G4"
# +- 68 "Ab4"
# +- 69 "A4"
# +- 70 "Bb4"
# +- 71 "B4"







