(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*128*2;
s.options.blockSize = 64*4;
s.options.maxNodes = 1024 * 16;
//s.options.sampleRate= 44100;
s.boot;
s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
s.recChannels = 4;
)


/////cube (

    w = s.sum;

    // left-right
    x =
    s[0] + s[1] + s[2] + s[3]
    - s[4] - s[5] - s[6] - s[7];

    // front-back
    y =
    s[0] + s[1] - s[2] - s[3]
    + s[4] + s[5] - s[6] - s[7];

    // up-down
    z =
    s[0] - s[1] + s[2] - s[3]
    + s[4] - s[5] + s[6] - s[7];


(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
~c5 = Buffer.readChannel(s,,channels:4 );
~c6 = Buffer.readChannel(s,,channels:5 );
~c7 = Buffer.readChannel(s,,channels:6 );
~c8 = Buffer.readChannel(s,,channels:7 );
)
(
(
{Out.ar(0,
	(
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8), loop: 0,doneAction:2)
	)*0.1
)}.play;

{Out.ar(1,
		(
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8), loop: 0,doneAction:2)
	)*0.2)}.play;

{Out.ar(2,
		(
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8), loop: 0,doneAction:2)
	)*0.2)}.play;

{Out.ar(3,
		(
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8), loop: 0,doneAction:2)
	)*0.2)}.play;
);


s.record(numChannels:4,duration:((9*60)+45));
)


(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
)
(
{
	var w,x,y,z
	w=PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 1,doneAction:2)
	x=PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 1,doneAction:2)
	y=PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 1,doneAction:2)
	z=PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 1,doneAction:2)
	Out.ar(0,BFDecode1.ar(w, x, y, z,[pi,pi.neg],[0.5pi,0.5pi.neg]));
}.play;

s.record(numChannels:2,duration:((9*60)+45));
)


////4 channels

(
Tdef(\x, {
Buffer.freeAll;
(
~c1 = Buffer.readChannel(s,,channels:0 );//flu
~c2 = Buffer.readChannel(s,,channels:1 );//bru
~c3 = Buffer.readChannel(s,,channels:2 );//bld
~c4 = Buffer.readChannel(s,,channels:3 );//frd
);
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
1.wait;
(
(
{Out.ar(0,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(1,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(2,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(3,
	 PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;
);


s.record(numChannels:4,duration:((25*60)+10));
)
	((45*60)+15).wait; "aaaaaaaaaaaaaazz".scramble.postln;





	Buffer.freeAll;
(
~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_175808.aiff",channels:0 );//flu
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_175808.aiff",channels:1 );//bru
~c3 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_175808.aiff",channels:2 );//bld
~c4 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_175808.aiff",channels:3 );//frd
);
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
1.wait;
(
(
{Out.ar(0,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(1,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(2,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(3,
	 PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;
);


s.record(numChannels:4,duration:((29*60)+35));
)
	((29*60)+35).wait; "aaaaaaaaaaaaaazz".scramble.postln;



		Buffer.freeAll;
(
~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_184301.aiff",channels:0 );//flu
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_184301.aiff",channels:1 );//bru
~c3 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_184301.aiff",channels:2 );//bld
~c4 = Buffer.readChannel(s"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_184301.aiff",,channels:3 );//frd
);
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
1.wait;
(
(
{Out.ar(0,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(1,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(2,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(3,
	 PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;
);


s.record(numChannels:4,duration:((45*60)+20));
)
	((45*60)+20).wait; "aaaaaaaaaaaaaazz".scramble.postln;





	Buffer.freeAll;
(
~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_193503.aiff",channels:0 );//flu
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_193503.aiff",channels:1 );//bru
~c3 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_193503.aiff",channels:2 );//bld
~c4 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_193503.aiff",channels:3 );//frd
);
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
1.wait;
(
(
{Out.ar(0,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(1,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(2,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(3,
	 PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;
);


s.record(numChannels:4,duration:((45*60)+12));
)
	((45*60)+12).wait; "aaaaaaaaaaaaaazz".scramble.postln;




	uffer.freeAll;
(
~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_203613.aiff",channels:0 );//flu
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_203613.aiff",channels:1 );//bru
~c3 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_203613.aiff",channels:2 );//bld
~c4 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/quad/SC_250725_203613.aiff",channels:3 );//frd
);
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
1.wait;
(
(
{Out.ar(0,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(1,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(2,
	PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;

{Out.ar(3,
	 PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0,doneAction:2)+
	PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3), loop: 0,doneAction:2)-
	PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4), loop: 0,doneAction:2))}.play;
);


s.record(numChannels:4,duration:((27*60)+12));
)
	((27*12)+12).wait; "aaaaaaaaaaaaaazz".scramble.postln;





 }).play;
)