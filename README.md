//////SETUP WIZARD//////////////////////////
///////////////////////////////////////////

////////The following build will only work with Internet Connection (after Installation No Internet Connection ist required):
/////////////////////////////////////////////

~download and install SuperCollider  https://supercollider.github.io
Note that project sybthf builds against SuperCollider 3.13.0, only MathLib Quark is required, other than core SuperCollider Objects and Ugens

~download files from synth folder from this Repository to a local new synth folder

~find SuperCollider startup file in SuperCollider file in User Library, APPDATA on Windows, Application Support on Mac

~open startup.scd and paste on the writing environment of SuperCollider, the contnet of startup.scd from this repository 

~save startup.scd and overwrite previous save

~close SuperCollider and reopen it, now it will open along with synthf and the sound engine running

~terminate the synth either by closing SuperCollider or quiting the server on the server window 

~knobs are clockwise 0 to 8 with 0 being12o clock.0 and 1 are quantized tone variation in complex relation and localization, 2 is tone variation range, 3 is drive, 4 is envelope attack, 6 is tempered fundamental from ultra low to mid/high, 7 is decay and 8 tempo.

~if turning tempo to max, preferably do not set max long attack and decay at the same time so the sound engine does not crash

~synthf output is 14 independent channels of audio,according to audio interface, n(12) channels are audible, quad instance full range -96db

~if unsure on speaker system dynamic range do not set drive to high at low pitch 

~system runs on windows pc, mac, linux and or raspberry pi 5
 


//////////Raspberry:

~ install jack

~ install SuperCollider

~ save synthf as startupfile at directory home/usr/config/SuperCollider

~start jack with prefered Audio Interface

~start SuperCollider

~ adjust window size in sc or screen resolution. Window size is 700-1200px by default 
