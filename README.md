 Qbit Setup Wizard
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////The following build will only work with Internet Connection (after Installation No Internet Connection ist required), 

CAUTION in setting fundamental and tonal range high: Nyquist crash,
very low fundamental will slow cook speaker driver coil, if unsure on speaker system dynamic range or speaker wattage do not set drive to high at very low pitch or at very high pitch. Preferably do not use Headphones.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

~download and install SuperCollider  https://supercollider.github.io
Note that project sybthf builds against SuperCollider 3.13.0, only MathLib Quark is required, other than core SuperCollider Objects and Ugens. so make sure there is access to quarks, git for mac and similarly for windows, or install MathLib manually 

~download startup.scd

~find SuperCollider startup.scd file in SuperCollider file in User Library, APPDATA on Windows, Application Support on Mac

~open startup.scd and paste on the writing environment of SuperCollider, the content of startup.scd from this repository 

~on this line in the file ~img_print = Image.open("/home/pi/Desktop/synth/image1.jpg");///////////////paste image image1.jpg , copy paste or drag and drop in the parentheses image1.jpg from your location. You should see in the parentheses only the new file path in ""

~save startup.scd and overwrite previous save

~close SuperCollider and reopen it, now it will open along with synthf and the sound engine running

~terminate the synth either by closing SuperCollider or quiting the server on the server window 

~audio knobs are clockwise 0 to 9 with 0 being 11o clock. 0 and 1 are quantized tone variation in complex relation and localization,2 reverb mix and softclip gain, 3 is tone variation range, 4 is drive, 5 is envelope attack,6 scale tonal range, 7 is tempered fundamental from sub low to mid/high, 8 is decay and 9 tempo.

~control knobs on the right pannel are in series from left to right gain, compressor wavelength size, lowend cutt, reverb room size

~if turning tempo to max, preferably do not set max long attack and decay at the same time so the sound engine does not crash

~synthf output is 4 independent channels of audio and 1024 virtual channels. According to audio interface, n(4) channels are audible, full range

~system runs on windows pc, mac, linux and or raspberry pi 5

~if you set extreme value combinations that will crash the synth but not the server, just return knobs to normal and the sound will normalize 
 


//////////Raspberry:

~ install jack

~ install SuperCollider

~ save synthf as startupfile at directory home/usr/config/SuperCollider

~start jack with prefered Audio Interface

~start SuperCollider

~ adjust window size in sc or screen resolution. Window size is 700-1200px by default 
