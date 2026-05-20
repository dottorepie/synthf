
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*8;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
s.boot;
s.makeGui(w);
//s.meter;
//s.freqscope;
//s.scope;
);
/////////copy paste image path in parentheses
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
~img = Image.open("/Users/amimid/Desktop/synth/path1.jpg");//////////////////////////////////paste image path1.jpg
~img_print = Image.open("/Users/amimid/Documents/monad/image1.jpg");///////////////paste image image1.jpg
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

({
var c=0, color,xx=0,yy=0,r=[],g=[],b=[],h_count=0;
~cx=[]; ~cy=[];  ~cz=[];
~height=~img.height;
~width=~img.width;

	~img.height.do {
				~img.width.do {
         color = ~img.getColor(xx, yy);
	[color.red, color.green, color.blue].postln;
			r=r++color.red;
			g=g++color.green;
         	b=b++color.blue;
xx=xx+1;
				};
				xx=0;
				yy=yy+1;
    };
			r=r+0.0001;  g=g+0.0001;  b=b+0.0001;

        ~cx=~cx++r;
		~cy=~cy++g;
		~cz=~cz++b;
		}.value;
);
s.waitForBoot{
Tdef(\drone, {
////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
(
~note=49;
(
{
var nn=1.neg;
~scalee=~note.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg;
~scaleee=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);
~sc=[~scalee,~scaleee];
);
(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(2pi/992)); ~ph=992.collect{~n=~n+(2pi/992);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);
(
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
signal=Signal.sineFill(~signalSize,~array,[0],~ph);
wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
}.value;
);
/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,drive=0,c=0,az=0,el=0,scalee=0,dicay=0.5,attack=0.01,sc=20;
var fund,fu=16,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,mp,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4;

env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.001)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.001)/16256);

xx=Spherical(~width*~height,az,el).x.round(1).asInteger;
yy=Spherical(~width*~height,az,el).y.round(1).asInteger;
zz=Spherical(~width*~height,az,el).z.round(1).asInteger;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));
mp=Spherical(sc,polytope.theta,  polytope.phi);

b_x=2.pow(Select.kr(mp.x.round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
b_y=2.pow(Select.kr(mp.y.round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
b_z=2.pow(Select.kr(mp.z.round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
mod_x=polytope.x;
mod_y=polytope.y;
mod_z=polytope.z;
phasex=(Complex(1,mod_x).theta*4);
phasey=(Complex(1,mod_y).theta*4);
phasez=(Complex(1,mod_z).theta*2);

freq1=(fund)*b_x;
freq2=(fund)*b_y;
freq3=(fund)*b_z;
amp1=b_x.reciprocal*expansion.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal;

sig1=LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:300).abs*SinOsc.ar(freq1,phase:phasex)),freq1*heavy,amp1);
sig2=LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:300).abs*SinOsc.ar(freq2,phase:phasey)),freq2*heavy,amp2);
sig3=LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:300).abs*SinOsc.ar(freq3,phase:phasez)),freq3*heavy,amp3);

g_ch1 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(1,~az[0],~el[0]).x) +
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[0],~el[0]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[0],~el[0]).z)
);
g_ch2 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(1,~az[1],~el[1]).x)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[1],~el[1]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[1],~el[1]).z)
);
g_ch3 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi ).wrap(~el[2],~el[1])).x *
Spherical(1,~az[2],~el[2]).x)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[2],~el[2]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[2],~el[2]).z)
);
g_ch4 = (
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(1,~az[3],~el[3]).x) +
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(1,~az[3],~el[3]).y)+
(Spherical(1,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(1,~az[3],~el[3]).z)
);

Out.ar(0,sig1*env);Out.ar(1,sig2*env);Out.ar(0,(sig3*env*2.sqrt.reciprocal)!2);
(
Out.ar(0,sig1*env*g_ch1);Out.ar(1,sig1*env*g_ch2);Out.ar(2,sig1*env*g_ch3);Out.ar(3,sig1*env*g_ch4);
Out.ar(0,sig2*env*g_ch1);Out.ar(1,sig2*env*g_ch2);Out.ar(2,sig2*env*g_ch3);Out.ar(3,sig2*env*g_ch4);
Out.ar(0,sig3*env*g_ch1);Out.ar(1,sig3*env*g_ch2);Out.ar(2,sig3*env*g_ch3);Out.ar(3,sig3*env*g_ch4);
)

}).add;
);
1.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
(
(
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;	~r2=0;
(
~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];
3.do{
~x=bank.collect{
m1=m1+1;
b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };
bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
~dur=~dur++~dur1++~dur2++~dur3;
)}.value);
);

~gain=1;~drive=0;~c=0;~az=0;~el=0;~scalee=0;~attack=0.01;~decay=1;~incr1=0;~incr2=0;
~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);~incr=0;~g=((1+5.sqrt)/2);~s=(1+2.sqrt);
~seq= Pseq(~dur ,inf).asStream;
TempoClock.default.tempo_(0.01);

~pattern = Pdef(\1,
Pbind(\instrument, \synth,\dur, ~seq,\gain, Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },
\c, Pfunc { ~c },\az, Pseries(0, Pfunc{~incr1}, inf).collect(_.wrap(pi.neg, pi)).asStream,
\el, Pseries(0, Pfunc{~incr2}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)).asStream,
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay },\scalee, Pfunc { ~scalee };
));
~pattern.play;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
(
var size=1000,sk=size/50,compass,n=(2pi/9).neg;
var px1=0,py1=0,px2=0,py2=0,px3=0,py3=0;
var px4=0,py4=0,px5=0,py5=0,px6=0,py6=0;
var px7=0,py7=0,px8=0,py8=0,px9=0,py9=0;

w = Window("gui", Rect(10, 10, sizex, sizey)).front;
~vw = UserView(w, w.view.bounds).drawFunc_({ ~img_print.drawInRect(~vw.bounds)});
Pen.translate(size/2,size/2);
compass=9.collext{n=n+(2pi/9); Polar.new(size/10,n);};
(
~sl1=Knob.new(~vw, Rect.aboutPoint(compass.[0].x @ compass.[0].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,127,1,56).round(1).asInteger;
~sc=value;
});
);
(
~sl2=Knob.new(~vw, Rect.aboutPoint(compass.[1].x @ compass.[1].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,127,0.00001,10);
~gain=value;
});
);
(
~sl3=Knob.new(~vw, Rect.aboutPoint(compass.[2].x @ compass.[2].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,127,0.001,4);
~attck=value;
});
);
(
~sl4=Knob.new(~vw, Rect.aboutPoint(compass.[3].x @ compass.[3].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.27,0,1).round(1).asInteger;
~attck=value;
});
);
(
~sl5=Knob.new(~vw, Rect.aboutPoint(compass.[4].x @ compass.[4].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.27,0,16256*2).round(1).asInteger;
~c=value;
});
);
(
~sl6=Knob.new(~vw, Rect.aboutPoint(compass.[5].x @ compass.[5].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,127,0.001,5);
~dicay=value;
});
);
(
~sl7=Knob.new(~vw, Rect.aboutPoint(compass.[6].x @ compass.[6].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,127,0.1,100);
TempoClock.default.tempo_(value);
});
);
(
~sl8=Knob.new(~vw, Rect.aboutPoint(compass.[7].x @ compass.[7].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.27,0.degrad,2pi-(2pi/~gold)).round((2pi/992).degrad);
~incr1=value;
});
);
(
~sl9=Knob.new(~vw, Rect.aboutPoint(compass.[8].x @ compass.[8].y, sk, sk)).
background_(Color.white).knobColor_(Color.black).action_({
arg obj;
var value;
value=obj.value.27,0.degrad,pi-(pi/~gold)).round((pi/992).degrad);
~incr=value;
});
);
);
}.value
)
);
}); Tdef(\drone).play;
}
)








///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////spaces
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////tetrahedron
(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////cube
(
~azimuth=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////octahedron
(
~azimuth=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~elevation=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////icosahedron
(
~azimuth=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~elevation=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////dodecahedron
(
~azimuth=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~elevation=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Rhombic dodecahedron
(
~azimuth=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~elevation=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////cuboctahedron
(
~azimuth=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~elevation=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Rhombic Triacontahedron
(
~azimuth=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~elevation=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////icosidodecahedron
(
~azimuth=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~elevation=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];
)*/


