#HI2D.rb
# 28 Sep 2017
#Module

## Helper functions
# in HI.rb def midi2note(n)
###############
## a function to copy a one dimensional array
# in HI.rb  def array_copy(x)
###############
# in HI.rb def HI.listit(list)
###############
# in HI.rb   def HI.midi2noteList(list)
###############
# in HI.rb    def HI.getScaleIndex(tone,scal)
###############
# in HI.rb     def HI.gScaleI2(ref,keyscale,d,octshift,e)
###############
# in HI.rb       def HI.shiftOnScale(tone,keyscale,n)
###############
# in HI.rb         def HI.invertNote(ref,tone,keyscale)
###############
###############
# Functions for HI2D
###############

module HI2D
  p self
  @main=nil
  @mm=nil
  def HI2D.link(x,y)
    p self
    @main=x
    @mm=y
    @main.puts "Linking HI2D"
  end
  def HI2D.ddd(x)
    @main.puts "There1",x
  end
  
  #end # module HI2D
  ### Copying a 2D array
  def HI2D.array_copy2D(x)
    @main.puts "Array Copy 2D"
    y=[]
    i=0
    while i<x.length
      y.push(HI.array_copy(x[i]))
      i+=1
    end
    return y
  end
  #end # module HI2D
  ###############
  def HI2D.revtime(s)
    @main.puts "Revtime"
    rval= HI2D.array_copy2D(s)
    rt=[]
    i=0
    while i < s.length
      rt.push(rval[i][1])
      i+=1
    end
    rt=rt.reverse
    i=0
    while i < s.length
      rval[i][1]=rt[i]
      i+=1
    end
    return rval
  end
  ###############
  def HI2D.insertRest(s)
    @main.puts "REST"
    rval= HI2D.array_copy2D(s)
    i=0
    while i < s.length
      rval[i][0]=:r
      i+=1
    end
    return rval
  end #insertRest
  
  
  ### insert harmony and inversion functions
  ##### Starting function for shiftOnScale and invertNote
  ##### gets the index of a note in a scale
  ##### The shifting function
  ###########################
  
  #############
  def HI2D.invert(s,ref,keyscale)
    @main.puts "invert"
    rval= HI2D.array_copy2D(s)
    i=0
    while i < s.length
      #     puts "I"
      if rval[i][0] != "R"
        rval[i][0]=HI.invertNote(ref,rval[i][0],keyscale)
      end
      i+=1
    end
    return rval
  end
  #############
  def HI2D.harmonize(s,keyscale,n) #invert(s,ref,keyscale)
    @main.puts "Harmonize"
    rval= HI2D.array_copy2D(s)
    i=0
    while i < s.length
      if rval[i][0] != "R"
        rval[i][0]=HI.shiftOnScale(rval[i][0],keyscale,n)
      end
      i+=1
    end
    return rval
  end
end # module HI2D
