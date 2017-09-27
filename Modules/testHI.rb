#testHI.rb
# 27 Sep 2017
# Objective to create module

  ##################
  ###
  require "C:/MySPmodules/HI.rb"
  HI.link(self)
  
  ##### things to twiddle
  amplitude= 0.3
  use_synth :fm
  #use_synth :beep
  key = :C5
  mode= :major
  #mode= :minor
  #mode= :augmented
  #mode= :augmented2
  #mode= :diminished
  #puts scale_names
  rel= 1.5 # note release
  refn=0
  interval=2
  #####################################
  nle=[0.25,0.25,0.125,0.25] # note length
  nle=nle.ring
  top1=[4,5,6,7]
  bot1=[3,2,1,0]
  define :tune2 do |amplitude|
    keyscale=scale key, mode
    ref= note keyscale[refn]
    ref=ref-12
    ks=HI.array_copy(keyscale)
    ks1= ks.slice(0,4)+(ks.slice(4,7)).reverse
    puts keyscale
    puts ks
    puts ks1
    puts HI.midi2note(60)
    with_fx :level, amp: amplitude do
      k=0
      while k<3
        j=0
        while j<top1.length
          i=0
          while i<nle.length
            v1a=keyscale[top1[j]]
            v1b=keyscale[bot1[j]]
            v2a=HI.shiftOnScale(v1a,keyscale,interval)
            v2b=HI.shiftOnScale(v1b,keyscale,-interval)
            v3a=HI.invertNote(ref,v1a,keyscale)
            v3b=HI.invertNote(ref,v1b,keyscale)
            play(v1a,release: nle[i]*rel)
            play(v1b,release: nle[i]*rel)
            
            if(k>0)
              play(v2a,release: nle[i]*rel)
              play(v2b,release: nle[i]*rel)
            end
            if(k==2)
              play(v3a,release: nle[i]*rel)
              play(v3b,release: nle[i]*rel)
            end
            sleep nle[i]
            i+=1
          end
          j+=1
        end
        j=3
        while j>0
          i=0
          while i<ks1.length
            v1=HI.shiftOnScale(ks1.reverse[i],keyscale,j)
            v2=HI.shiftOnScale(v1,keyscale,-interval) #-5)
            v3=HI.invertNote(ref,v1,keyscale)
            play(v1,release: nle[i]*rel)
            if(k>0)then play(v2,release: nle[i]*rel) end
            if(k==2)then play(v3,release: nle[i]*rel) end
            sleep nle[i]
            i+=1
          end #next i
          j-=1
        end #next j
        puts keyscale
        play(76,release: 0.25*rel)
        sleep 0.25
        play(72,release: 0.25*rel)
        sleep 0.25
        k+=1
      end #next k
      i=0
      et=[0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.5]
      while i<keyscale.length
        play(keyscale[i],release: et[i]*rel)
        sleep et[i]
        i+=1
      end
      
    end # with_fx
  end #tune2
  
  
  
  mode= :major
  tune2 0.25
  
  