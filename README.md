//////SETUP WIZARD/////////////////////////////////////

~synthf_1.scd is reviewed version on spaces (geodesies) timbre

~synthf_1a.scd is machine with entropy



~download and install SuperCollider 3.14 and further https://supercollider.github.io

~download files from synth folder from this Repository to a local new synth folder

~find SuperCollider startup file in SuperCollider file in User Library

~open startup.scd and paste in the writing environment of SuperCollider, the contnet of the synthf.scd. Copy Paste or drag and drop image1.jpg or any Image you prefer, in the parentheses(with no image loaded the synth will crash)

~save startup.scd and overwrite previous save

~close SuperCollider and reopen it, now it will open along with synthf and the sound engine running

~terminate the synth either by closing SuperCollider or quiting the server on the server window 


~knobs on the synth are clockwise with 12oclock being knob0 and so on till 9

~knobs are 0:azimuthal tonal argument, 1:elevation tonal argument, 2:tonal range, 3:drive, 4:envelope attack, 5:toggle scales (phrygian,dorian), 6:fundamental, 7:envelope decay, 8:tempo (0.001,128)Hz (beats per second)

~if turning tempo to max, preferably do not set max long attack and decay at the same time so the sound engine does not crash

~synthf output is 4 independent channels of audio,according to audio interface, n(4) channels are audible, tetrahedral full range quadrophony

~if unsure on speaker system dynamic range do not set drive to high at low pitch 

~system runs on windows pc, mac, linux and or raspberry pi 5
 

~use server window gain slider to adjust limiting of drive

~feel free to use an image of your choosing for background 

~recommended use: musical autonomon, laptop orchestra, beatmaking


~each time the software opens, synthf has a new random timbre, to set one solid, set fixed random seed in synthf.scd, or modulated via routine or envelope, or spherical data from one azimuth and one elevation array. Loading an image as timbre can be found in image-to-sound Repository. Adding or miltiplying more oscillators and other Ugens will most propably crash the synth, as it runs one one server (~10% of CPU usage)

~in file synthf at the bottom arrays of spaces can be found (polytopes), these can be used in rhythm array section or for developing more ouput channels (or use VBAP plugin), or for timbre

~instructions for spaces can be found here https://en.wikipedia.org/wiki/Polytope_compound under Dual Compounds section

~Dual Compounds, ig cube-octahedron, are in two kinds, core and hull, choosing a hull will make the sound hollistic, a core will render the sound timbre local.

~The number of vertices on the chosen compound polytope is also the number of possible tones as in notes. Choosing a polytope of higher number of vertices expands the tonal range of the instrument. Tetrahedral spaces have a limited range, Cubic a median range Icosahedral a full range. Anything above or below that range is either orchestral or percussion. Vertices can be set either via randomness, distribution or geodesic methods

~32 vertices is the normal range. This range affects greatly the disconance of the scales in toggle. Setting more or other scales for the toggle knob function is recommended (Scale.directory)




///////Raspberry:

~ install jack

~ install SuperCollider and Quark

~ save synthf as startupfile at directory /home/usr/config/SuperCollider

~ adjust window size in sc or screen resolution. Window size is 1200px by default 
