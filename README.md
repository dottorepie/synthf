~download and install SuperCollider https://supercollider.github.io

~download synth folder from this Repository


~open SuperCollider, at the options tab select Language, then click Quarks

~in Quarks window select and install MathLib (ths library has to be installed in order for the synth to work)

~open synthf.scd file from downloaded synth folder, find this line at the top, ~img_print = Image.open();, and drag and drop, or copy paste file image1.jpg, also from synth folder, in the parenteses of the code line. Any image file can be loaded, important is that the parenthese contain the file path as .open("file path"). Save synthf.scd 

~close SuperCollider

~find SuperColider startup file in SuperCollider file in User Library

~open startup.scd and paste in the writing environment of SC the contnet of the synthf.scd (with no image pasted the synth will crash)

~save startup.scd and overwrite previous save

~close SuperCollider and reopen it, now it will open along with synthf and the sound engine running

~terminate the synth either by closing SuperCollider or quiting the server on the server window 
