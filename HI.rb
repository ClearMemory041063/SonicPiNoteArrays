#HI.rb
# 28 Sep 2017
# Objective to create module
## Helper functions
#####################
## start the module
module HI
  p self
  @M=nil
  def HI.link(x)
    p self
    @M=x
    @M.puts "Linking"
  end
  
  ###############
  ## a function to copy a one dimensional array
  def HI.array_copy(x)
    y=[]
    i=0
    while i<x.length
      y.push(x[i])
      i+=1
    end
    return y
  end
  ###############
  
  def HI.midi2note(n)
    nn=@M.note(n)
    if nn==nil
      #    @M.puts "nil seen",nn
      return nn
    else
      nn= @M.note_info(nn)
      #    @M.puts nn
      nnn=nn.to_s.split(":")
      #  @M.puts nnn
      mmm= nnn[3].chop
      return mmm
    end
  end # midi2note
  #####
  def HI.listit(list)
    i=0
    while i<list.length
      @M.puts i,list[i]
      i+=1
    end
  end # listit
  #####
  def HI.midi2noteList(list)
    rval=[]
    i=0
    while i<list.length
      rval.push [list[i], midi2note(list[i])]
      i+=1
    end
    return rval
  end #midi2noteList
  ##### Starting function for shiftOnScale and invertNote
  ##### gets the index of a note in a scale
  def HI.getScaleIndex(tone,scal)
    #@M.puts "SCALEiNDEX",tone,scal
    aoct=0
    octshift=0
    #  scal.pop #remove the last element of scale
    base=scal[0] # the MIDI number of the scale start
    a=@M.note(tone) # is the MIDI number of the note to harmonize
    #  @M.puts "note(tone)=",a
    if a==nil then return a end
    #  aa=note(tone)
    # @M.puts "a aa=",a,aa
    #adjust the value to fall in the range of the scale
    while a<base # note is lower
      a+=12
      octshift-=12
    end
    while a>(base+12) # note is higher
      a-=12
      octshift+=12
    end
    b=a
    # @M.puts "b=",b
    #see if the adjusted note is in the scale
    e=0
    if scal.include?(b)
      #    @M.puts "b in scal"
      e=0
    else
      if scal.include?(b+1)
        e=1
      else
        if scal.include?(b-1)
          e=-1
        else
          return nil #:C7 #signal an error
        end
      end
    end
    #  @M.puts "e=",e
    c=scal.index(b+e) # cis the index of the note
    #  @M.puts "onote=",c,midi2note(scal[c])
    #  @M.puts "z",c,octshift,e
    retval=[c,octshift,e]
    #  @M.puts retval
    return retval
  end # getScaleIndex
  ##### Finishing function for shiftOnScale and invertNote
  def HI.gScaleI2(ref,keyscale,d,octshift,e)
    aoct=0
    n=d
    #  octshift=refindex[1]-toneindex[1]
    #  e=refindex[2]-toneindex[2]
    aa=@M.note(ref)
    while d>6
      #    @M.puts "D>>"
      aoct=1 #flag it for later
      d=d-7
    end
    while d<0
      #    @M.puts "D<<"
      aoct=-1 #flag it for later
      d=d+7
    end
    #@M.puts "d=",d,keyscale[d],aoct
    d=keyscale[d]+aoct*12+octshift
    #  @M.puts "DD",aa,d,aa-d
    if (d < aa)  && (n<0)
      #   @M.puts "DDD",aa,d,aa-d
      while (aa-d) > 12
        #     @M.puts "UP"
        d+=12
      end
    end
    #  @M.puts d,midi2note(d)
    return d
  end # gScaleI2
  ##### The shifting function
  def HI.shiftOnScale(tone,keyscale,n)
    #  @M.puts tone,keyscale,n
    xxx=getScaleIndex(tone,keyscale)
    #  @M.puts "XXX=",xxx
    if xxx==nil then return :r end
    d=xxx[0]+n
    octshift=xxx[1]
    e=xxx[2]
    retval=gScaleI2(tone,keyscale,d,octshift,e)
    retval=midi2note(retval)
    #@M.puts retval
    return retval
  end # shiftOnScale
  ##### The inversion function
  def HI.invertNote(ref,tone,keyscale)
    #  puts "IN",ref,tone
    refindex=getScaleIndex(ref,keyscale)
    toneindex=getScaleIndex(tone,keyscale)
    puts "Tone index=",toneindex
    puts "Ref index=",refindex
    if toneindex==nil then return :r end
    if refindex==nil then return :r end
    d=refindex[0]-toneindex[0]
    octshift=refindex[1]-toneindex[1]
    e=refindex[2]-toneindex[2]
    retval=gScaleI2(ref,keyscale,d,octshift,e)
    retval=midi2note(retval)
    return retval
  end # invertNote
end #module HI
