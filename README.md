//////SETUP WIZARD//////////////////////////
///////////////////////////////////////////

~synthf_1.scd is reviewed version on spaces (geodesies) timbre

~synthf_1a.scd is machine with entropy

////////////////////////////////////////////
////////The following build will only work with Internet Connection (after Installation No Internet Connection ist required):
/////////////////////////////////////////////

~download and install SuperCollider  https://supercollider.github.io
Note that project sybthf builds against SuperCollider 3.13.0, only MathLib Quark is required, other than core SuperCollider Objects and Ugens

~download files from synth folder from this Repository to a local new synth folder

~find SuperCollider startup file in SuperCollider file in User Library, APPDATA on Windows, Application Support on Mac

~open startup.scd and paste on the writing environment of SuperCollider, the contnet of the synthf_1.scd , synthf or 1a, or directly use startup.scd from this repository 

~ then copy paste or drag and drop image1.jpg or any image you prefer, in the parentheses on Line 20 like so, ~img_print = Image.open("image1 path");, (with no image loaded the synth will crash, after pasting in the parentheses of Image.open(), the new path should appear in "")

~save startup.scd and overwrite previous save

~close SuperCollider and reopen it, now it will open along with synthf and the sound engine running

~terminate the synth either by closing SuperCollider or quiting the server on the server window 

~knobs on the synth are clockwise with 12oclock being knob0 and so on till 9

~knobs are 0:azimuthal tonal argument, 1:elevation tonal argument, 2:tonal range, 3:drive, 4:envelope attack, 5:toggle scales (phrygian,dorian), 6:fundamental, 7:envelope decay, 8:tempo (0.001,128)Hz (beats per second)

~ for startup.scd knobs are clockwise 0 to 8 with 0 being12o clock.0 and 1 are quantized tone variation in complex relation and localization, 2 is tone variation range, 3 is drive, 4 is envelope attack, 5 is scale toggle (chromatiqc, diminished,dorian),
6 is tempered fundamental from ultra low to mid/high, 7 is decay and 8 tempo.

~if turning tempo to max, preferably do not set max long attack and decay at the same time so the sound engine does not crash

~synthf output is 4 independent channels of audio,according to audio interface, n(4) channels are audible, tetrahedral full range quadrophony

~if unsure on speaker system dynamic range do not set drive to high at low pitch 

~system runs on windows pc, mac, linux and or raspberry pi 5
 
~use server window gain slider to adjust limiting of drive

~in file synthf at the bottom, some readymade arrays of spaces can be found (polytopes), these can be used in rhythm array section or for developing more ouput channels (or use VBAP plugin), or for timbre

~instructions for spaces can be found here https://en.wikipedia.org/wiki/Polytope_compound under Dual Compounds section

~Dual Compounds, ig cube-octahedron, are in two kinds, core and hull, choosing a hull will make the sound hollistic, a core will render the sound timbre local.

~The number of vertices on the chosen compound polytope is also the number of possible tones as in notes. Choosing a polytope of higher number of vertices expands the tonal range of the instrument. Tetrahedral spaces have a limited range, Cubic a median range Icosahedral a full range. Anything above or below that range is either orchestral or percussion. Vertices can be set either via randomness, distribution or geodesic methods.

~version synthf_1a hast a random Limit on tonal range at every sonic event

~32 vertices is the normal range. This range affects greatly the disconance of the scales in toggle. Setting more or other scales for the toggle knob function is recommended (Scale.directory)

~ startup file has 4 vertices as real output channels and 2 as imaginary, (6 virtual channels, octahedral symmetry). Therofore echolocations are presnt through time, playback on stereo or quad is irrelevant, speaker placement also greatly, wattage only noise++


//////////Raspberry:

~ install jack

~ install SuperCollider

~ save synthf as startupfile at directory home/usr/config/SuperCollider

~start jack with prefered Audio Interface

~start SuperCollider

~ adjust window size in sc or screen resolution. Window size is 700-1200px by default 
