
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Quarks.install("MathLib");
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
//s.meter;
//s.freqscope;
s.scope;
);
~img_print = Image.open("/Users/amimid/Documents/Literary/Portfolio/SUPERCOLLIDER/2026/synth/image1.jpg");///////////////paste image image1.jpg
s.waitForBoot{
Tdef(\drone, {
//~controlBus = Bus.control(s, 1);

////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre///////////////////////////////////////cuboctahedron
(
/*(
~s1=pi.rand2;~s2=pi.rand2;~s3=pi.rand2;~s4=pi.rand2;
~s5=pi.rand2;~s6=pi.rand2;~s7=pi.rand2;~s8=pi.rand2;
~s9=pi.rand2;~s10=pi.rand2;~s11=pi.rand2;~s12=pi.rand2;
~az=[~s1,~s2,~s3,~s4,~s5,~s6,~s7,~s8,~s9,~s10,~s11,~s12];
~el=[~s1.rand2/2,~s2.rand2/2,~s3.rand2/2,~s4.rand2/2,~s5.rand2/2,
~s6.rand2/2,~s7.rand2/2,~s8.rand2/2,~s9.rand2/2,~s10.rand2/2,
~s11.rand2/2,~s12.rand2/2];
)*/
/*(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)*/
			(
{
var  sph1,sph2,az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt),mag1=1,mag2=1,azimuth,elevation;
~az=[];~el=[];

32.do{
azimuth=32.collect{
az1 = (az1+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
el1 = (el1+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta;
};
elevation=32.collect{
az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
el2 = (el2+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));
sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi;
};
angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;
az1=0;el1=0;az2=0;el2=0;
}
}.value;
			);
~vertices=1024;
{
var timbre,raz,rel,difaz,difel,nn=1.neg,n;
difaz=~vertices.collect{nn=nn+1;~az.[nn]};
nn=1.neg;
difel=~vertices.collect{nn=nn+1;~el.[nn]};
n=0; ~cx=[]; ~cy=[]; ~cz=[];
~vertices.do{
~cx=~cx++Spherical(1,difaz.[n],difel.[n]).x;
~cy=~cy++Spherical(1,difaz.[n],difel.[n]).y;
~cz=~cz++Spherical(1,difaz.[n],difel.[n]).z;
n=n+1;
};
}.value;
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
signal=Signal.sineFill(~signalSize,~array,~ph);
wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
}.value;
);
(
~note=32;
(
{
var nn=1.neg;
~scale=~note.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
}.value;
);
);
/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,
c=0,az=0,el=0,dicay=0.5,attack=0.01,sc=20,ssc=1,mix=0,busArray1 = #[0,1,2,3];
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps,mpf;
var s_x,s_y,s_z,threshold,c1,c2,c3;

s1=Rand(0, ~vertices-1).round(1).asInteger;s2=Rand(0, ~vertices-1).round(1).asInteger;
s3=Rand(0, ~vertices-1).round(1).asInteger;s4=Rand(0, ~vertices-1).round(1).asInteger;

env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

xx=Spherical(~vertices,az,el).x.round(1).asInteger.abs;
yy=Spherical(~vertices,az,el).y.round(1).asInteger.abs;
zz=Spherical(~vertices,az,el).z.round(1).asInteger.abs;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));

///osc
mp=Spherical(sc,polytope.theta, polytope.phi);
mps=Spherical(ssc,polytope.theta, polytope.phi);
mpf=Spherical(1,polytope.theta, polytope.phi);

b_x=2.pow(mp.x.round(1)/16256);
b_y=2.pow(mp.y.round(1)/16256);
b_z=2.pow(mp.z.round(1)/16256);
s_x=2.pow(Select.kr(mps.x.round(1).asInteger.abs,~scale).asInteger /12);
s_y=2.pow(Select.kr(mps.y.round(1).asInteger.abs,~scale).asInteger /12);
s_z=2.pow(Select.kr(mps.z.round(1).asInteger.abs,~scale).asInteger /12);

mod_x=mpf.x;
mod_y=mpf.y;
mod_z=mpf.z;
//phasex=(Complex(1,mod_x).theta*2);
//phasey=(Complex(1,mod_y).theta*2);
//phasez=(Complex(1,mod_z).theta*2);
phasex = atan(mod_x);
phasey = atan(mod_y);
phasez = atan(mod_z);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;
amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),mix,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),mix,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),mix,room);

////distortion
sig1=(SinOsc.ar(freq1*4,phase:phasex,mul:amp1/4)+(amp1)).abs*c1;
sig2=(SinOsc.ar(freq2*4,phase:phasey,mul:amp2/4)+(amp2)).abs*c2;
sig3=(SinOsc.ar(freq3*4,phase:phasez,mul:amp3/4)+(amp3)).abs*c3;

sig1=(sig1*mix.linlin(0,1,0.1,32)).softclip;
sig2=(sig2*mix.linlin(0,1,0.1,32)).softclip;
sig3=(sig3*mix.linlin(0,1,0.1,32)).softclip;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);

/////compresion
sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);
threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

/////spat
a1=a2=a3=a4=1;
g_ch1 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).z)
);
g_ch2 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2, ~el)*a2).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2,~el)*a2).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2, ~el)*a2).z)
);
g_ch3 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).z)
);
g_ch4 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).z)
);

(
Out.ar(busArray1.[0],LeakDC.ar(sig1*env*g_ch1));Out.ar(busArray1.[1],LeakDC.ar(sig1*env*g_ch2));
Out.ar(busArray1.[2],LeakDC.ar(sig1*env*g_ch3));Out.ar(busArray1.[3],LeakDC.ar(sig1*env*g_ch4));
Out.ar(busArray1.[0],LeakDC.ar(sig2*env*g_ch1));Out.ar(busArray1.[1],LeakDC.ar(sig2*env*g_ch2));
Out.ar(busArray1.[2],LeakDC.ar(sig2*env*g_ch3));Out.ar(busArray1.[3],LeakDC.ar(sig2*env*g_ch4));
Out.ar(busArray1.[0],LeakDC.ar(sig3*env*g_ch1));Out.ar(busArray1.[1],LeakDC.ar(sig3*env*g_ch2));
Out.ar(busArray1.[2],LeakDC.ar(sig3*env*g_ch3));Out.ar(busArray1.[3],LeakDC.ar(sig3*env*g_ch4));
)

}).add;
);1.wait;
(
SynthDef.new(\synth1,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,
c=0,az=0,el=0,dicay=0.5,attack=0.01,sc=20,ssc=1,mix=0,busArray2= #[4,5,6,7];
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps,mpf;
var s_x,s_y,s_z,threshold,c1,c2,c3;

s1=Rand(0, ~vertices-1).round(1).asInteger;s2=Rand(0, ~vertices-1).round(1).asInteger;
s3=Rand(0, ~vertices-1).round(1).asInteger;s4=Rand(0, ~vertices-1).round(1).asInteger;

env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

xx=Spherical(~vertices,az,el).x.round(1).asInteger.abs;
yy=Spherical(~vertices,az,el).y.round(1).asInteger.abs;
zz=Spherical(~vertices,az,el).z.round(1).asInteger.abs;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));

///osc
mp=Spherical(sc,polytope.theta, polytope.phi);
mps=Spherical(ssc,polytope.theta, polytope.phi);
mpf=Spherical(1,polytope.theta, polytope.phi);

b_x=2.pow(mp.x.round(1)/16256);
b_y=2.pow(mp.y.round(1)/16256);
b_z=2.pow(mp.z.round(1)/16256);
s_x=2.pow(Select.kr(mps.x.round(1).asInteger.abs,~scale).asInteger /12);
s_y=2.pow(Select.kr(mps.y.round(1).asInteger.abs,~scale).asInteger /12);
s_z=2.pow(Select.kr(mps.z.round(1).asInteger.abs,~scale).asInteger /12);

mod_x=mpf.x;
mod_y=mpf.y;
mod_z=mpf.z;
//phasex=(Complex(1,mod_x).theta*2);
//phasey=(Complex(1,mod_y).theta*2);
//phasez=(Complex(1,mod_z).theta*2);
phasex = atan(mod_x);
phasey = atan(mod_y);
phasez = atan(mod_z);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;
amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),mix,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),mix,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),mix,room);

////distortion
sig1=(SinOsc.ar(freq1*4,phase:phasex,mul:amp1/4)+(amp1)).abs*c1;
sig2=(SinOsc.ar(freq2*4,phase:phasey,mul:amp2/4)+(amp2)).abs*c2;
sig3=(SinOsc.ar(freq3*4,phase:phasez,mul:amp3/4)+(amp3)).abs*c3;

sig1=(sig1*mix.linlin(0,1,0.1,32)).softclip;
sig2=(sig2*mix.linlin(0,1,0.1,32)).softclip;
sig3=(sig3*mix.linlin(0,1,0.1,32)).softclip;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);

/////compresion
sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);
threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

/////spat
a1=a2=a3=a4=1;
g_ch1 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).z)
);
g_ch2 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2, ~el)*a2).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2,~el)*a2).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2, ~el)*a2).z)
);
g_ch3 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).z)
);
g_ch4 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).z)
);

(
Out.ar(busArray2.[0],LeakDC.ar(sig1*env*g_ch1));Out.ar(busArray2.[1],LeakDC.ar(sig1*env*g_ch2));
Out.ar(busArray2.[2],LeakDC.ar(sig1*env*g_ch3));Out.ar(busArray2.[3],LeakDC.ar(sig1*env*g_ch4));
Out.ar(busArray2.[0],LeakDC.ar(sig2*env*g_ch1));Out.ar(busArray2.[1],LeakDC.ar(sig2*env*g_ch2));
Out.ar(busArray2.[2],LeakDC.ar(sig2*env*g_ch3));Out.ar(busArray2.[3],LeakDC.ar(sig2*env*g_ch4));
Out.ar(busArray2.[0],LeakDC.ar(sig3*env*g_ch1));Out.ar(busArray2.[1],LeakDC.ar(sig3*env*g_ch2));
Out.ar(busArray2.[2],LeakDC.ar(sig3*env*g_ch3));Out.ar(busArray2.[3],LeakDC.ar(sig3*env*g_ch4));
)

}).add;
);
1.wait;
(
SynthDef.new(\synth2,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,
c=0,az=0,el=0,dicay=0.5,attack=0.01,sc=20,ssc=1,mix=0,busArray = #[8,9,10,11];
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps,mpf;
var s_x,s_y,s_z,threshold,c1,c2,c3;

s1=Rand(0, ~vertices-1).round(1).asInteger;s2=Rand(0, ~vertices-1).round(1).asInteger;
s3=Rand(0, ~vertices-1).round(1).asInteger;s4=Rand(0, ~vertices-1).round(1).asInteger;

env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

xx=Spherical(~vertices,az,el).x.round(1).asInteger.abs;
yy=Spherical(~vertices,az,el).y.round(1).asInteger.abs;
zz=Spherical(~vertices,az,el).z.round(1).asInteger.abs;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));

///osc
mp=Spherical(sc,polytope.theta, polytope.phi);
mps=Spherical(ssc,polytope.theta, polytope.phi);
mpf=Spherical(1,polytope.theta, polytope.phi);

b_x=2.pow(mp.x.round(1)/16256);
b_y=2.pow(mp.y.round(1)/16256);
b_z=2.pow(mp.z.round(1)/16256);
s_x=2.pow(Select.kr(mps.x.round(1).asInteger.abs,~scale).asInteger /12);
s_y=2.pow(Select.kr(mps.y.round(1).asInteger.abs,~scale).asInteger /12);
s_z=2.pow(Select.kr(mps.z.round(1).asInteger.abs,~scale).asInteger /12);

mod_x=mpf.x;
mod_y=mpf.y;
mod_z=mpf.z;
//phasex=(Complex(1,mod_x).theta*2);
//phasey=(Complex(1,mod_y).theta*2);
//phasez=(Complex(1,mod_z).theta*2);
phasex = atan(mod_x);
phasey = atan(mod_y);
phasez = atan(mod_z);

freq1=(fund)*b_x*s_x;
freq2=(fund)*b_y*s_y;
freq3=(fund)*b_z*s_z;
amp1=b_x.reciprocal*expansion.reciprocal*s_x.reciprocal;
amp2=b_y.reciprocal*expansion.reciprocal*s_y.reciprocal;
amp3=b_z.reciprocal*expansion.reciprocal*s_z.reciprocal;

c1=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1200).abs*
SinOsc.ar(freq1,phase:phasex)),freq1,heavy,amp1),mix,room);
c2=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1200).abs*
SinOsc.ar(freq2,phase:phasey)),freq2,heavy,amp2),mix,room);
c3=FreeVerb.ar(BPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1200).abs*
SinOsc.ar(freq3,phase:phasez)),freq3,heavy,amp3),mix,room);

////distortion
sig1=(SinOsc.ar(freq1*4,phase:phasex,mul:amp1/4)+(amp1)).abs*c1;
sig2=(SinOsc.ar(freq2*4,phase:phasey,mul:amp2/4)+(amp2)).abs*c2;
sig3=(SinOsc.ar(freq3*4,phase:phasez,mul:amp3/4)+(amp3)).abs*c3;

sig1=(sig1*mix.linlin(0,1,0.1,32)).softclip;
sig2=(sig2*mix.linlin(0,1,0.1,32)).softclip;
sig3=(sig3*mix.linlin(0,1,0.1,32)).softclip;

///spectral compensation
//sig1=BRF.ar(c1,freq1/2,heavy);
//sig2=BRF.ar(c2,freq2/2,heavy);
//sig3=BRF.ar(c3,freq3/2,heavy);
//sig1=BRF.ar(c1,freq1*4,heavy);
//sig2=BRF.ar(c2,freq2*4,heavy);
//sig3=BRF.ar(c3,freq3*4,heavy);

/////compresion
sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);
threshold=(((343/s_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
sig1=Compander.ar(sig1,c1*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig2=Compander.ar(sig2,c2*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);
sig3=Compander.ar(sig3,c3*env,threshold,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.000001);

/////spat
a1=a2=a3=a4=1;
g_ch1 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s1, ~az)*a1,Select.kr(s1, ~el)*a1).z)
);
g_ch2 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2, ~el)*a2).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2,~el)*a2).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s2, ~az)*a2,Select.kr(s2, ~el)*a2).z)
);
g_ch3 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s3, ~az)*a3,Select.kr(s3, ~el)*a3).z)
);
g_ch4 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),Select.kr(s4, ~az)*a4,Select.kr(s4, ~el)*a4).z)
);

(
Out.ar(busArray.[0],LeakDC.ar(sig1*env*g_ch1));Out.ar(busArray.[1],LeakDC.ar(sig1*env*g_ch2));
Out.ar(busArray.[2],LeakDC.ar(sig1*env*g_ch3));Out.ar(busArray.[3],LeakDC.ar(sig1*env*g_ch4));
Out.ar(busArray.[0],LeakDC.ar(sig2*env*g_ch1));Out.ar(busArray.[1],LeakDC.ar(sig2*env*g_ch2));
Out.ar(busArray.[2],LeakDC.ar(sig2*env*g_ch3));Out.ar(busArray.[3],LeakDC.ar(sig2*env*g_ch4));
Out.ar(busArray.[0],LeakDC.ar(sig3*env*g_ch1));Out.ar(busArray.[1],LeakDC.ar(sig3*env*g_ch2));
Out.ar(busArray.[2],LeakDC.ar(sig3*env*g_ch3));Out.ar(busArray.[3],LeakDC.ar(sig3*env*g_ch4));
)

}).add;
);1.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
(
(

({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=8,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;	~r2=0;
(
~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
(
~dur1b=[];~dur2b=[];~dur3b=[]; ~dxb=[];~dyb=[]; ~dzb=[]; ~durxb=[]; ~duryb=[]; ~durzb=[]; ~seq2=[];
bank.do{
							m1=m2=m3=~vertices.rand;
~xb=1.collect{
//m1=m1+1;
b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~yb=1.collect{
//m2=m2+1;
c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~zb=1.collect{
//m3=m3+1;
d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dxb=~dxb++~xb; ~dyb=~dyb++~yb;  ~dzb=~dzb++~zb;   ~xb=[]; ~yb=[]; ~zb=[];  r=r+90.degrad; };
bank.do{ ~dur1b=~dur1b++~dxb.[n];n=n+1;};n=0;
bank.do{ ~dur2b=~dur2b++~dyb.[n];n=n+1;};n=0;
bank.do{ ~dur3b=~dur3b++~dzb.[n];n=n+1;};n=0;
~seq2=~seq2++~dur1b++~dur2b++~dur3b;
)}.value);
);
(
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=8,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;	~r2=0;
(
~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
(
~dur1c=[];~dur2c=[];~dur3c=[]; ~dxc=[];~dyc=[]; ~dzc=[]; ~durxc=[]; ~duryc=[]; ~durzc=[]; ~seq3=[];
bank.do{
							m1=m2=m3=~vertices.rand;
~xc=1.collect{
//m1=m1+1;
b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~yc=1.collect{
//m2=m2+1;
c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~zc=1.collect{
//m3=m3+1;
d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dxc=~dxc++~xc; ~dyc=~dyc++~yc;  ~dzc=~dz++~zc;   ~xc=[]; ~yc=[]; ~zc=[];  r=r+90.degrad; };
bank.do{ ~dur1c=~dur1c++~dxc.[n];n=n+1;};n=0;
bank.do{ ~dur2c=~dur2c++~dyc.[n];n=n+1;};n=0;
bank.do{ ~dur3c=~dur3c++~dzc.[n];n=n+1;};n=0;
~seq3=~seq3++~dur1c++~dur2c++~dur3c;
)}.value);
);
(

({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=8,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;	~r2=0;
(
~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
(
~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~seq1=[];
bank.do{
							m1=m2=m3=~vertices.rand;
~x=1.collect{
//m1=m1+1;
b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~y=1.collect{
//m2=m2+1;
c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~z=1.collect{
//m3=m3+1;
d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };
bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
~seq1=~seq1++~dur1++~dur2++~dur3;
)}.value);
);

~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);
~gain=1;~drive=0;~c=0;~attack=0.01;~decay=1;~sc=1;~s_size=1;~lowend=20;~room=0;
~gain1=1;~drive1=0;~c1=0;~attack1=0.01;~decay1=1;~sc1=1;~s_size1=1;~lowend1=20;~room1=0;
~gain2=1;~drive2=0;~c2=0;~attack2=0.01;~decay2=1;~sc2=1;~s_size2=1;~lowend2=20;~room2=0;
~incr1=0;~incr2=0;~ssc=1;~incr11=0;~incr21=0;~ssc1=1;
~incr12=0;~incr22=0;~ssc2=1;~mix=0;~mix1=0;~mix2=0;


~clock1 = TempoClock.new(0.1);
~clock2 = TempoClock.new(0.1);
~clock3 = TempoClock.new(0.1);

~pattern1 = Pdef(\1,
Pbind(\instrument, \synth,
\dur, Pseq(~seq1 ,inf),\s_size,Pfunc { ~s_size }, \lowend,Pfunc { ~lowend }, \room,Pfunc { ~room },
\gain,Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },
\c, Pfunc { ~c },\mix, Pfunc{~mix},
\az, Pseries(0, Pfunc{~incr1}, inf).collect(_.wrap(pi.neg, pi)),
\el, Pseries(0, Pfunc{~incr2}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)),
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern2 = Pdef(\2,
Pbind(\instrument, \synth1,
\dur, Pseq(~seq2 ,inf),\s_size,Pfunc { ~s_size1}, \lowend,Pfunc { ~lowend1 }, \room,Pfunc { ~room1},
\gain,Pfunc { ~gain1 }, \sc, Pfunc { ~sc1},\drive, Pfunc { ~drive1 },
\c, Pfunc { ~c1},\mix, Pfunc{~mix1},
\az, Pseries(0, Pfunc{~incr11}, inf).collect(_.wrap(pi.neg, pi)),
\el, Pseries(0, Pfunc{~incr21}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)),
\attack,  Pfunc { ~attack1 }, \dicay, Pfunc { ~decay1 }, \ssc, Pfunc{~ssc1};
));
~pattern3 = Pdef(\3,
Pbind(\instrument, \synth2,
\dur, Pseq(~seq3 ,inf),\s_size,Pfunc { ~s_size2 }, \lowend,Pfunc { ~lowend2 }, \room,Pfunc { ~room2 },
\gain,Pfunc { ~gain2 }, \sc, Pfunc { ~sc2 },\drive, Pfunc { ~drive2 },
\c, Pfunc { ~c2 },\mix, Pfunc{~mix2},
\az, Pseries(0, Pfunc{~incr12}, inf).collect(_.wrap(pi.neg, pi)),
\el, Pseries(0, Pfunc{~incr22}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)),
\attack,  Pfunc { ~attack2 }, \dicay, Pfunc { ~decay2 }, \ssc, Pfunc{~ssc2};
));
~pattern1.play(~clock1);
~pattern2.play(~clock2);
~pattern3.play(~clock3);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size,sk,compass,n,scl,r,ssk=20,scope1,scope2,scope3,scope4,meter,w1;
size=700; sk=(size/30); n=(2pi/9).neg; scl=(size/4); r=2;
compass=10.collect{n=n+(2pi/10); (exp(Complex(0,1)*n)*scl)};

w1 = Window("synthf0", Rect(50, 50, size*2, size)).front;
~vw = UserView(w1, Rect(0,0,size,size)).drawFunc_({ ~img_print.drawInRect(~vw.bounds)});
~vw1 = UserView(w1,Rect(size,0,size,size)).background_(Color.black);
~logView = ListView( ~vw1, Rect(0, 0, 40, 750))
.background_(Color.black).stringColor_(Color.white)
.font_(Font("Arial", 20))
.items_([]);
~logItems = List.new;
~log = { |msg| {~logItems.add(msg); if(~logItems.size > 200) { ~logItems.removeAt(0);  };
 ~logView.items_(~logItems.asArray); ~logView.value_(~logItems.size - 1); }.defer;};

scope1 = FreqScopeView(~vw1, Rect(sk+100+50,sk+ssk+30,  sk+350, sk+100));
scope1.active_(true);scope1.dbRange_(120);scope1.inBus_(0);scope1.freqMode_(1);
scope2 = FreqScopeView(~vw1, Rect(sk+100+50, sk+ssk+180,  sk+350, sk+100));
scope2.active_(true);scope2.dbRange_(120);scope2.inBus_(1);scope2.freqMode_(1);
scope3 = FreqScopeView(~vw1, Rect(sk+100+50, sk+ssk+330, sk+350, sk+100));
scope3.active_(true);scope3.dbRange_(120);scope3.inBus_(2);scope3.freqMode_(1);
scope4 = FreqScopeView(~vw1, Rect(sk+100+50, sk+ssk+480,  sk+350, sk+100));
scope4.active_(true);scope4.dbRange_(120);scope4.inBus_(3);scope4.freqMode_(1);
(
~sl1=Knob.new(~vw, Rect.aboutPoint((compass.[0].real+(size/r)) @ (compass.[0].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,16256).round(1).asInteger.postln;
~sc=value;
~log.(value.asString);
});
);
(
~sl2=Knob.new(~vw, Rect.aboutPoint((compass.[1].real+(size/r)) @ (compass.[1].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*8).neg,(16256*4)).round(1).asInteger.postln;
~drive=value;
~log.(value.asString);
});
);
(
~sl4=Knob.new(~vw, Rect.aboutPoint((compass.[2].real+(size/r)) @ (compass.[2].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,4).postln;
~attack=value;
~log.(value.asString);
});
);
(
~sl3=Knob.new(~vw, Rect.aboutPoint((compass.[3].real+(size/r)) @ (compass.[3].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value;
~log.(value.asString);
});
);
(
~sl5=Knob.new(~vw, Rect.aboutPoint((compass.[4].real+(size/r)) @ (compass.[4].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c=value;
~log.(value.asString);
});
);
(
~sl6=Knob.new(~vw, Rect.aboutPoint((compass.[5].real+(size/r)) @ (compass.[5].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,8).postln;
~decay=value;
~log.(value.asString);
});
);
(
~sl7=Knob.new(~vw, Rect.aboutPoint((compass.[6].real+(size/r))@ (compass.[6].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1/16,64).round(1/64).postln;
~clock1.tempo = value;
~log.(value.asString);
});
);
(
~sl8=Knob.new(~vw, Rect.aboutPoint((compass.[7].real+(size/r))@ (compass.[7].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~silver)).round((2pi/992).degrad).postln;
~incr1=value;
~log.(value.asString);
});
);
(
~sl9=Knob.new(~vw, Rect.aboutPoint((compass.[8].real+(size/r))@ (compass.[8].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,pi-(pi/~gold)).round((pi/992).degrad).postln;
~incr2=value;
~log.(value.asString);
});
);
(
~sl10=Knob.new(~vw, Rect.aboutPoint((compass.[9].real+(size/r))@ (compass.[9].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix=value;
~log.(value.asString);
});
);
(
~sl01=Knob.new(~vw1, Rect.new(sk+sk+50+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.001,10).postln;
~gain=value;
~log.(value.asString);
});
);
(
~sl02=Knob.new(~vw1, Rect.new(sk+sk+150+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.05,10).postln;
~s_size=value;
~log.(value.asString);
});
);
(
~sl03=Knob.new(~vw1, Rect.new(sk+sk+250+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,10,100).postln;
~lowend=value;
~log.(value.asString);
});
);
(
~sl04=Knob.new(~vw1, Rect.new(sk+sk+350+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room=value;
~log.(value.asString);
});
)
}.defer
);
			(
{
var size,sk,compass,n,scl,r,ssk=20,scope1,scope2,scope3,scope4,meter,w2;
size=700; sk=(size/30); n=(2pi/9).neg; scl=(size/4); r=2;
compass=10.collect{n=n+(2pi/10); (exp(Complex(0,1)*n)*scl)};

w2 = Window("synthf1", Rect(100, 50, size*2, size)).front;
~vw3 = UserView(w2, Rect(0,0,size,size)).drawFunc_({ ~img_print.drawInRect(~vw3.bounds)});
~vw13 = UserView(w2,Rect(size,0,size,size)).background_(Color.black);
~logView2 = ListView( ~vw13, Rect(0, 0, 40, 750))
.background_(Color.black).stringColor_(Color.white)
.font_(Font("Arial", 20))
.items_([]);
~logItems2 = List.new;
~log2 = { |msg| {~logItems2.add(msg); if(~logItems2.size > 200) { ~logItems2.removeAt(0);  };
 ~logView2.items_(~logItems2.asArray); ~logView2.value_(~logItems2.size - 1); }.defer;};

scope1 = FreqScopeView(~vw13, Rect(sk+100+50,sk+ssk+30,  sk+350, sk+100));
scope1.active_(true);scope1.dbRange_(120);scope1.inBus_(8);scope1.freqMode_(1);
scope2 = FreqScopeView(~vw13, Rect(sk+100+50, sk+ssk+180,  sk+350, sk+100));
scope2.active_(true);scope2.dbRange_(120);scope2.inBus_(9);scope2.freqMode_(1);
scope3 = FreqScopeView(~vw13, Rect(sk+100+50, sk+ssk+330, sk+350, sk+100));
scope3.active_(true);scope3.dbRange_(120);scope3.inBus_(10);scope3.freqMode_(1);
scope4 = FreqScopeView(~vw13, Rect(sk+100+50, sk+ssk+480,  sk+350, sk+100));
scope4.active_(true);scope4.dbRange_(120);scope4.inBus_(11);scope4.freqMode_(1);
(
~sl12=Knob.new(~vw3, Rect.aboutPoint((compass.[0].real+(size/r)) @ (compass.[0].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,16256).round(1).asInteger.postln;
~sc2=value;
~log2.(value.asString);
});
);
(
~sl22=Knob.new(~vw3, Rect.aboutPoint((compass.[1].real+(size/r)) @ (compass.[1].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*8).neg,(16256*4)).round(1).asInteger.postln;
~drive2=value;
~log2.(value.asString);
});
);
(
~sl42=Knob.new(~vw3, Rect.aboutPoint((compass.[2].real+(size/r)) @ (compass.[2].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,4).postln;
~attack2=value;
~log2.(value.asString);
});
);
(
~sl32=Knob.new(~vw3, Rect.aboutPoint((compass.[3].real+(size/r)) @ (compass.[3].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc2=value;
~log2.(value.asString);
});
);
(
~sl52=Knob.new(~vw3, Rect.aboutPoint((compass.[4].real+(size/r)) @ (compass.[4].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c2=value;
~log2.(value.asString);
});
);
(
~sl62=Knob.new(~vw3, Rect.aboutPoint((compass.[5].real+(size/r)) @ (compass.[5].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,8).postln;
~decay2=value;
~log2.(value.asString);
});
);
(
~sl72=Knob.new(~vw3, Rect.aboutPoint((compass.[6].real+(size/r))@ (compass.[6].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1/16,64).round(1/64).postln;
~clock3.tempo = value;
~log2.(value.asString);
});
);
(
~sl82=Knob.new(~vw3, Rect.aboutPoint((compass.[7].real+(size/r))@ (compass.[7].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~silver)).round((2pi/992).degrad).postln;
~incr12=value;
~log2.(value.asString);
});
);
(
~sl92=Knob.new(~vw3, Rect.aboutPoint((compass.[8].real+(size/r))@ (compass.[8].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,pi-(pi/~gold)).round((pi/992).degrad).postln;
~incr22=value;
~log2.(value.asString);
});
);
(
~sl102=Knob.new(~vw3, Rect.aboutPoint((compass.[9].real+(size/r))@ (compass.[9].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix2=value;
~log2.(value.asString);
});
);
(
~sl012=Knob.new(~vw13, Rect.new(sk+sk+50+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.001,10).postln;
~gain2=value;
~log2.(value.asString);
});
);
(
~sl022=Knob.new(~vw13, Rect.new(sk+sk+150+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.05,10).postln;
~s_size2=value;
~log2.(value.asString);
});
);
(
~sl032=Knob.new(~vw13, Rect.new(sk+sk+250+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,10,100).postln;
~lowend2=value;
~log2.(value.asString);
});
);
(
~sl042=Knob.new(~vw13, Rect.new(sk+sk+350+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room2=value;
~log2.(value.asString);
});
)
}.defer
);
(
{
var size,sk,compass,n,scl,r,ssk=20,scope1,scope2,scope3,scope4,meter,w3;
size=700; sk=(size/30); n=(2pi/9).neg; scl=(size/4); r=2;
compass=10.collect{n=n+(2pi/10); (exp(Complex(0,1)*n)*scl)};

w3 = Window("synthf2", Rect(200, 50, size*2, size)).front;
~vw2 = UserView(w3, Rect(0,0,size,size)).drawFunc_({ ~img_print.drawInRect(~vw2.bounds)});
~vw12 = UserView(w3,Rect(size,0,size,size)).background_(Color.black);
~logView1 = ListView( ~vw12, Rect(0, 0, 40, 750))
.background_(Color.black).stringColor_(Color.white)
.font_(Font("Arial", 20))
.items_([]);
~logItems1 = List.new;
~log1 = { |msg| {~logItems1.add(msg); if(~logItems1.size > 200) { ~logItems1.removeAt(0);  };
 ~logView1.items_(~logItems1.asArray); ~logView1.value_(~logItems1.size - 1); }.defer;};

scope1 = FreqScopeView(~vw12, Rect(sk+100+50,sk+ssk+30,  sk+350, sk+100));
scope1.active_(true);scope1.dbRange_(120);scope1.inBus_(4);scope1.freqMode_(1);
scope2 = FreqScopeView(~vw12, Rect(sk+100+50, sk+ssk+180,  sk+350, sk+100));
scope2.active_(true);scope2.dbRange_(120);scope2.inBus_(5);scope2.freqMode_(1);
scope3 = FreqScopeView(~vw12, Rect(sk+100+50, sk+ssk+330, sk+350, sk+100));
scope3.active_(true);scope3.dbRange_(120);scope3.inBus_(6);scope3.freqMode_(1);
scope4 = FreqScopeView(~vw12, Rect(sk+100+50, sk+ssk+480,  sk+350, sk+100));
scope4.active_(true);scope4.dbRange_(120);scope4.inBus_(7);scope4.freqMode_(1);
(
~sl11=Knob.new(~vw2, Rect.aboutPoint((compass.[0].real+(size/r)) @ (compass.[0].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,16256).round(1).asInteger.postln;
~sc1=value;
~log1.(value.asString);
});
);
(
~sl21=Knob.new(~vw2, Rect.aboutPoint((compass.[1].real+(size/r)) @ (compass.[1].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*8).neg,(16256*4)).round(1).asInteger.postln;
~drive1=value;
~log1.(value.asString);
});
);
(
~sl41=Knob.new(~vw2, Rect.aboutPoint((compass.[2].real+(size/r)) @ (compass.[2].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,4).postln;
~attack1=value;
~log1.(value.asString);
});
);
(
~sl31=Knob.new(~vw2, Rect.aboutPoint((compass.[3].real+(size/r)) @ (compass.[3].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc1=value;
~log1.(value.asString);
});
);
(
~sl51=Knob.new(~vw2, Rect.aboutPoint((compass.[4].real+(size/r)) @ (compass.[4].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c1=value;
~log1.(value.asString);
});
);
(
~sl61=Knob.new(~vw2, Rect.aboutPoint((compass.[5].real+(size/r)) @ (compass.[5].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,8).postln;
~decay1=value;
~log1.(value.asString);
});
);
(
~sl71=Knob.new(~vw2, Rect.aboutPoint((compass.[6].real+(size/r))@ (compass.[6].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1/16,64).round(1/64).postln;
~clock2.tempo = value;
~log1.(value.asString);
});
);
(
~sl81=Knob.new(~vw2, Rect.aboutPoint((compass.[7].real+(size/r))@ (compass.[7].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~silver)).round((2pi/992).degrad).postln;
~incr11=value;
~log1.(value.asString);
});
);
(
~sl91=Knob.new(~vw2, Rect.aboutPoint((compass.[8].real+(size/r))@ (compass.[8].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,pi-(pi/~gold)).round((pi/992).degrad).postln;
~incr21=value;
~log1.(value.asString);
});
);
(
~sl101=Knob.new(~vw2, Rect.aboutPoint((compass.[9].real+(size/r))@ (compass.[9].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~mix1=value;
~log1.(value.asString);
});
);
(
~sl011=Knob.new(~vw12, Rect.new(sk+sk+50+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.001,10).postln;
~gain1=value;
~log1.(value.asString);
});
);
(
~sl021=Knob.new(~vw12, Rect.new(sk+sk+150+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.05,10).postln;
~s_size1=value;
~log1.(value.asString);
});
);
(
~sl031=Knob.new(~vw12, Rect.new(sk+sk+250+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,10,100).postln;
~lowend1=value;
~log1.(value.asString);
});
);
(
~sl041=Knob.new(~vw12, Rect.new(sk+sk+350+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,1).postln;
~room1=value;
~log1.(value.asString);
});
)
}.defer
);
		);
}); Tdef(\drone).play;
}
)

s.record(numChannels:4);





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
