Copying Arrays ReadMe.md
#### Strange Behavior When Arrays are Copied
[Return to main page]( https://github.com/ClearMemory041063/SonicPiNoteArrays)

See example1.rb for the code
#### Copying simple variables

```
# Start with simple variables
a=1
b=a
puts "a=",a,"b=",b
b=2
puts "a=",a,"b=",b
#  ?? "a=" 1 "b=" 1
# ?? "a=" 1 "b=" 2
#
```
#### Arrays don't copy the same way!

```
# Now try it with an array
c=[1,2,3,4]
d=c
puts "c=",c
puts "d=",d
d[1]=99
puts "c=",c
puts "d=",d
# Notice that both arrays changed
#  ?? "c=" [1, 2, 3, 4]
#  ?? "d=" [1, 2, 3, 4]
#  ?? "c=" [1, 99, 3, 4]
#  ?? "d=" [1, 99, 3, 4]
# Actually there is only one array c and d both point to it in the computer memory
```
#### How to copy an array
Write a function

```
## a function to copy a one dimensional array
def array_copy(x)
  y=[]
  i=0
  while i<x.length
    y.push(x[i])
    i+=1
  end
  return y
end

e=[1,2,3,4]
f=array_copy(e)
puts "e=",e
puts "f",f
f[1]=99
puts "e=",e
puts "f",f
# That's better
# ?? "e=" [1, 2, 3, 4]
# ?? "f" [1, 2, 3, 4]
# ?? "e=" [1, 2, 3, 4]
# ?? "f" [1, 99, 3, 4]
```
#### What Happens When array_copy is Used on a 2D Array?

```
## try array_copy with a 2D array
ee=[
  [:A4,1],
  [:B4,2],
  [:C4,3],
  [:D4,4],
]
ff=array_copy(ee)
puts "ee=",ee
puts "ff=",ff
ff[1][0]=:r
puts "ee=",ee
puts "ff=",ff
# The problem is back!
# ?? "ee=" [[:A4, 1], [:B4, 2], [:C4, 3], [:D4, 4]]
# ?? "ff=" [[:A4, 1], [:B4, 2], [:C4, 3], [:D4, 4]]
# ?? "ee=" [[:A4, 1], [:r, 2], [:C4, 3], [:D4, 4]]
# ?? "ff=" [[:A4, 1], [:r, 2], [:C4, 3], [:D4, 4]]
```
#### Copying a 2D Array

```
### Copying a 2D array
def array_copy2D(x)
  y=[]
  i=0
  while i<x.length
    y.push(array_copy(x[i]))
    i+=1
  end
  return y
end

eee=[
  [:A4,1],
  [:B4,2],
  [:C4,3],
  [:D4,4],
]
fff=array_copy2D(eee)
puts "eee=",eee
puts "fff=",fff
fff[1][0]=:r
puts "eee=",eee
puts "fff=",fff
# That's better
# ?? "eee=" [[:A4, 1], [:B4, 2], [:C4, 3], [:D4, 4]]
# ?? "fff=" [[:A4, 1], [:B4, 2], [:C4, 3], [:D4, 4]]
# ?? "eee=" [[:A4, 1], [:B4, 2], [:C4, 3], [:D4, 4]]
# ?? "fff=" [[:A4, 1], [:r, 2], [:C4, 3], [:D4, 4]]
```
