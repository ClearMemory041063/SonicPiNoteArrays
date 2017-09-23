Melodic Inversion ReadMe.md
#### Melodic Inversion

[Return to main page]( https://github.com/ClearMemory041063/SonicPiNoteArrays)

##### Reworked the Harmony Function to Produce the Inversion Function

By splitting the harmony function in two parts, both the harmony and inversion functions were implemented. In each of the two functions part one is invoked, some operations occur peculiar to either the harmony or inversion, and the second part is called to return either the harmonized note or the inverted note.
Inversion5.rb contains the resulting functions with a series of tests used to validate the functions

##### InversionEx1.rb
This plays the theme,the harmony and then the theme plus the harmoized theme

##### InversionEx2.rb
This plays the theme, the inverted theme and then both the theme and the inverted theme.

##### InversionEx3.rb
This plays the theme, the theme + inverted theme C4, the theme + inverted theme E4, the theme + inverted theme G4, and finally the theme + the harmoized theme with a shift of two scale notes up. Listen to it here:

[InversionEx3]( https://drive.google.com/open?id=0BxMOEsGLzwfeYW44UzhTaGNOcU0)

##### InversionEx4.rb
Repeat of Ex3 with some changes to the theme and using two different synthesiser voices. Listen to it here:

[InversionEx4]( https://drive.google.com/open?id=0BxMOEsGLzwfeMVdlOFNLbEZhMzQ)


