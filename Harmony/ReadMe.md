Harmony ReadMe.md
#### Harmony

[Return to main page]( https://github.com/ClearMemory041063/SonicPiNoteArrays)

#### Shifting by halftones doesn't produce harmony
Chromatic.rb plays a scale with a chromatic shift of a Major third (4). Each scale note and an up shifted note by 4 half tones are played together. The result is not the harmony we are looking for.

#### Example of harmony in the key of C Major
Just play an interval on the white notes only.
The C Major scale starting at middle C is C4,D4,E4,F4,G4,A4,B4,C5.

Play C4 and E4 together

then D4 and F4,

then E4 and G4,

then F4 and A4,

then G4 and B4,

then A4 and C5,

then B4 and D5, and finally

C5 and E5

Harmony1.rb plays the same scale as chromatic.rb but the shifted note is shifed up the scale by the scale interval. C4 to E4 is a shift of 2

ShiftOnScale.rb contains a function to shift notes by scale intervals. There are four tests funtions used to run the funtion through its paces.
The tone is the note to be shifted such as :C4.
Scal is a scale array based on the musical key. 
Example keyscale=scale :C4, :major
The argument n specifies the scale interval to shift the note.


```
def shiftOnScale(tone,scal,n)

## Test3 runs a major scales to produce chords
define :test3 do |amplitude|
  with_fx :level, amp: amplitude do
    keyscale=scale :C4, :major
    listit(midi2noteList(keyscale))
    j=0
    while j<keyscale.length
      nn=shiftOnScale(keyscale[j],keyscale,2)
      mm=shiftOnScale(keyscale[j],keyscale,5)
      puts midi2note(keyscale[j]),nn
      play(keyscale[j])
      play(nn)
      play(mm)
      sleep 0.5
      j+=1
    end
  end
end #test3
```

HarmonyEx2.rb plays the musical theme using harmony.
The following shows how the theme is harmonized.


```
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
```
As usual the song was saved as HarmonyEx2.abc and the runABC program was used to produce the sheet music as a pdf file named HarmonyEx2.pdf