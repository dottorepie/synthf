
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=31;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*256;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Quarks.install("MathLib");
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
s.meter;
s.freqscope;
s.scope;
);
~img_print = Image.open("/Users/amimid/Documents/Literary/Portfolio/SUPERCOLLIDER/2026/synthia/image1.jpg");///////////////paste image image1.jpg
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
arg gain=1,drive=0,c=0,az=0,el=0,dicay=0.5,attack=0.01,sc=20,ssc=1,mix=0;
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps;
var s_x,s_y,s_z,g_ch5,g_ch6,g_ch7,g_ch8,g_ch9,g_ch10;
var g_ch11,g_ch12,g_ch13,g_ch14,g_ch15;
var g_ch16,g_ch17,g_ch18,g_ch19,g_ch20,g_ch21,g_ch22;
var g_ch23,g_ch24,g_ch25,g_ch26,g_ch27,g_ch28,g_ch29,g_ch30,g_ch31;
var s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22;
var s23,s24,s25,s26,s27,s28,s29,s30,s31;
var a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20;
var a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31,mpf;
var out;

out=Rand(0, 30 ! 31).round.asInteger;

s1=~vertices.rand;s2=~vertices.rand;s3=~vertices.rand;s4=~vertices.rand;
s5=~vertices.rand;s6=~vertices.rand;s7=~vertices.rand;s8=~vertices.rand;
s9=~vertices.rand;s10=~vertices.rand;s11=~vertices.rand;s12=~vertices.rand;
s13=~vertices.rand;s14=~vertices.rand;s15=~vertices.rand;s16=~vertices.rand;
s17=~vertices.rand;s18=~vertices.rand;s19=~vertices.rand;s20=~vertices.rand;
s21=~vertices.rand;s22=~vertices.rand;s23=~vertices.rand;s24=~vertices.rand;
s25=~vertices.rand;s26=~vertices.rand;s27=~vertices.rand;s28=~vertices.rand;
s29=~vertices.rand;s30=~vertices.rand;s31=~vertices.rand;


env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.001)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.001)/16256);

xx=Spherical(~vertices,az,el).x.round(1).asInteger;
yy=Spherical(~vertices,az,el).y.round(1).asInteger;
zz=Spherical(~vertices,az,el).z.round(1).asInteger;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));

mp=Spherical(sc,polytope.theta, polytope.phi);
mps=Spherical(ssc,polytope.theta, polytope.phi);
mpf=Spherical(1,polytope.theta, polytope.phi);

b_x=2.pow(mp.x.round(1)/16256);
b_y=2.pow(mp.y.round(1)/16256);
b_z=2.pow(mp.z.round(1)/16256);
s_x=2.pow(Select.kr(mps.x.round(1),~scale) /12);
s_y=2.pow(Select.kr(mps.y.round(1),~scale) /12);
s_z=2.pow(Select.kr(mps.z.round(1),~scale) /12);

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

sig1=FreeVerb.ar(LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:1024).abs*
SinOsc.ar(freq1,phase:phasex)),freq1*heavy,amp1),mix,1);
sig2=FreeVerb.ar(LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:1024).abs*
SinOsc.ar(freq2,phase:phasey)),freq2*heavy,amp2),mix,1);
sig3=FreeVerb.ar(LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:1024).abs*
SinOsc.ar(freq3,phase:phasez)),freq3*heavy,amp3),mix,1);

sig1=(sig1*mix.linlin(0,1,1,28)).softclip;
sig2=(sig2*mix.linlin(0,1,1,28)).softclip;
sig3=(sig3*mix.linlin(0,1,1,28)).softclip;

/*a1=(1/4).rand2;a2=(1/4).rand2;a3=(1/4).rand2;a4=(1/4).rand2;
a5=(1/4).rand2;a6=(1/4).rand2;a7=(1/4).rand2;a8=(1/4).rand2;
a9=(1/4).rand2;a10=(1/4).rand2;a11=(1/4).rand2;a12=(1/4).rand2;
a13=(1/4).rand2;a14=(1/4).rand2;a15=(1/4).rand2;a16=(1/4).rand2;
a17=(1/4).rand2;a18=(1/4).rand2;a19=(1/4).rand2;a20=(1/4).rand2;
a21=(1/4).rand2;a22=(1/4).rand2;a23=(1/4).rand2;a24=(1/4).rand2;
a25=(1/4).rand2;a26=(1/4).rand2;a27=(1/4).rand2;a28=(1/4).rand2;
a29=(1/4).rand2;a30=(1/4).rand2;a31=(1/4).rand2;*/
a1=a2=a3=a4=(1/4).rand2;
a5=a6=a7=a8=(1/4).rand2;
a9=a10=a11=a12=(1/4).rand2;
a13=a14=a15=a16=(1/4).rand2;
a17=a18=a19=a20=(1/4).rand2;
a21=a22=a23=a24=(1/4).rand2;
a25=a26=a27=a28=(1/4).rand2;
a29=a30=a31=(1/4).rand2;

g_ch1 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s1]*a1,~el[s1]*a1).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s1]*a1,~el[s1]*a1).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s1]*a1,~el[s1]*a1).z)
);
g_ch2 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s2]*a2,~el[s2]*a2).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s2]*a2,~el[s2]*a2).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s2]*a2,~el[s2]*a2).z)
);
g_ch3 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s3]*a3,~el[s3]*a3).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s3]*a3,~el[s3]*a3).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s3]*a3,~el[s3]*a3).z)
);
g_ch4 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s4]*a4,~el[s4]*a4).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s4]*a4,~el[s4]*a4).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s4]*a4,~el[s4]*a4).z)
);
g_ch5 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s5]*a5,~el[s5]*a5).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s5]*a5,~el[s5]*a5).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s5]*a5,~el[s5]*a5).z)
);
g_ch6= (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s6]*a6,~el[s6]*a6).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s6]*a6,~el[s6]*a6).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s6]*a6,~el[s6]*a6).z)
);
g_ch7= (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s7]*a7,~el[s7]*a7).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s7]*a7,~el[s7]*a7).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s7]*a7,~el[s7]*a7).z)
);
g_ch8 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s8]*a8,~el[s8]*a8).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s8]*a8,~el[s8]*a8).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s8]*a8,~el[s8]*a8).z)
);
g_ch9 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s9]*a9,~el[s9]*a9).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s9]*a9,~el[s9]*a9).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s9]*a9,~el[s9]*a9).z)
);
g_ch10 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s10]*a10,~el[s10]*a10).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s10]*a10,~el[s10]*a10).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s10]*a10,~el[s10]*a10).z)
);
g_ch11 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s11]*a11,~el[s11]*a11).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s11]*a11,~el[s11]*a11).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s11]*a11,~el[s11]*a11).z)
);
g_ch12 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s12]*a12,~el[s12]*a12).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s12]*a12,~el[s12]*a12).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s12]*a12,~el[s12]*a12).z)
);
g_ch13 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s13]*a13,~el[s13]*a13).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s13]*a13,~el[s13]*a13).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s13]*a13,~el[s13]*a13).z)
);
g_ch14 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s14]*a14,~el[s14]*a14).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s14]*a14,~el[s14]*a14).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s14]*a14,~el[s14]*a14).z)
);
g_ch15 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s15]*a15,~el[s15]*a15).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s15]*a15,~el[s15]*a15).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s15]*a15,~el[s15]*a15).z)
);
g_ch16 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s16]*a16,~el[s16]*a16).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s16]*a16,~el[s16]*a16).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s16]*a16,~el[s16]*a16).z)
);
g_ch17 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s17]*a17,~el[s17]*a17).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s17]*a17,~el[s17]*a17).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s17]*a17,~el[s17]*a17).z)
);
g_ch18 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s18]*a18,~el[s18]*a18).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s18]*a18,~el[s18]*a18).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s18]*a18,~el[s18]*a18).z)
);
g_ch19 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s19]*a19,~el[s19]*a19).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s19]*a19,~el[s19]*a19).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s19]*a19,~el[s19]*a19).z)
);
g_ch20 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s20]*a20,~el[s20]*a20).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s20]*a20,~el[s20]*a20).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s20]*a20,~el[s20]*a20).z)
);
g_ch21 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s21]*a21,~el[s21]*a21).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s21]*a21,~el[s21]*a21).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s21]*a21,~el[s21]*a21).z)
);
g_ch22 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s22]*a22,~el[s22]*a22).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s22]*a22,~el[s22]*a22).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s22]*a22,~el[s22]*a22).z)
);
g_ch23 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s23]*a23,~el[s23]*a23).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s23]*a23,~el[s23]*a23).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s23]*a23,~el[s23]*a23).z)
);
g_ch24 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s24]*a24,~el[s24]*a24).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s24]*a24,~el[s24]*a24).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s24]*a24,~el[s24]*a24).z)
);
g_ch25 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s25]*a25,~el[s25]*a25).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s25]*a25,~el[s25]*a25).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s25]*a25,~el[s25]*a25).z)
);
g_ch26 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s26]*a26,~el[s26]*a26).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s26]*a26,~el[s26]*a26).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s26]*a26,~el[s26]*a26).z)
);
g_ch27 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s27]*a27,~el[s27]*a27).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s27]*a27,~el[s27]*a27).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s27]*a27,~el[s27]*a27).z)
);
g_ch28 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s28]*a28,~el[s28]*a28).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s28]*a28,~el[s28]*a28).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s28]*a28,~el[s28]*a28).z)
);
g_ch29 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s29]*a29,~el[s29]*a29).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s29]*a29,~el[s29]*a29).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s29]*a29,~el[s29]*a29).z)
);
g_ch30 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s30]*a30,~el[s30]*a30).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s30]*a30,~el[s30]*a30).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s30]*a30,~el[s30]*a30).z)
);
g_ch31 = (
(Spherical(sig1.abs.range(0.001,1),(polytope.theta),(polytope.phi)).x *
Spherical(sig1.range(0.001,1),~az[s31]*a31,~el[s31]*a31).x) +
(Spherical(sig2.abs.range(0.001,1),(polytope.theta),(polytope.phi)).y *
Spherical(sig2.range(0.001,1),~az[s31]*a31,~el[s31]*a31).y)+
(Spherical(sig3.abs.range(0.001,1),(polytope.theta),(polytope.phi)).z *
Spherical(sig3.range(0.001,1),~az[s31]*a31,~el[s31]*a31).z)
);
(
Out.ar(out.[0],sig1*env*g_ch1);Out.ar(out.[1],sig1*env*g_ch2);
Out.ar(out.[2],sig1*env*g_ch3);Out.ar(out.[3],sig1*env*g_ch4);
Out.ar(out.[4],sig1*env*g_ch5);Out.ar(out.[5],sig1*env*g_ch6);
Out.ar(out.[6],sig1*env*g_ch7);Out.ar(out.[7],sig1*env*g_ch8);
Out.ar(out.[8],sig1*env*g_ch9);Out.ar(out.[9],sig1*env*g_ch10);
Out.ar(out.[10],sig1*env*g_ch11);Out.ar(out.[11],sig1*env*g_ch12);
Out.ar(out.[12],sig1*env*g_ch13);Out.ar(out.[13],sig1*env*g_ch14);
Out.ar(out.[14],sig1*env*g_ch15);Out.ar(out.[15],sig1*env*g_ch16);
Out.ar(out.[16],sig1*env*g_ch17);Out.ar(out.[17],sig1*env*g_ch18);
Out.ar(out.[18],sig1*env*g_ch19);Out.ar(out.[19],sig1*env*g_ch20);
Out.ar(out.[20],sig1*env*g_ch21);Out.ar(out.[21],sig1*env*g_ch22);
Out.ar(out.[22],sig1*env*g_ch23);Out.ar(out.[23],sig1*env*g_ch24);
Out.ar(out.[24],sig1*env*g_ch25);Out.ar(out.[25],sig1*env*g_ch26);
Out.ar(out.[26],sig1*env*g_ch27);Out.ar(out.[27],sig1*env*g_ch28);
Out.ar(out.[28],sig1*env*g_ch29);Out.ar(out.[29],sig1*env*g_ch30);Out.ar(out.[30],sig1*env*g_ch31);

Out.ar(out.[0],sig2*env*g_ch1);Out.ar(out.[1],sig2*env*g_ch2);
Out.ar(out.[2],sig2*env*g_ch3);Out.ar(out.[3],sig2*env*g_ch4);
Out.ar(out.[4],sig2*env*g_ch5);Out.ar(out.[5],sig2*env*g_ch6);
Out.ar(out.[6],sig2*env*g_ch7);Out.ar(out.[7],sig2*env*g_ch8);
Out.ar(out.[8],sig2*env*g_ch9);Out.ar(out.[9],sig2*env*g_ch10);
Out.ar(out.[10],sig2*env*g_ch11);Out.ar(out.[11],sig2*env*g_ch12);
Out.ar(out.[12],sig2*env*g_ch13);Out.ar(out.[13],sig2*env*g_ch14);
Out.ar(out.[14],sig2*env*g_ch15);Out.ar(out.[15],sig2*env*g_ch16);
Out.ar(out.[16],sig2*env*g_ch17);Out.ar(out.[17],sig2*env*g_ch18);
Out.ar(out.[18],sig2*env*g_ch19);Out.ar(out.[19],sig2*env*g_ch20);
Out.ar(out.[20],sig2*env*g_ch21);Out.ar(out.[21],sig2*env*g_ch22);
Out.ar(out.[22],sig2*env*g_ch23);Out.ar(out.[23],sig2*env*g_ch24);
Out.ar(out.[24],sig2*env*g_ch25);Out.ar(out.[25],sig2*env*g_ch26);
Out.ar(out.[26],sig2*env*g_ch27);Out.ar(out.[27],sig2*env*g_ch28);
Out.ar(out.[28],sig2*env*g_ch29);Out.ar(out.[29],sig2*env*g_ch30);Out.ar(out.[30],sig2*env*g_ch31);

Out.ar(out.[0],sig3*env*g_ch1);Out.ar(out.[1],sig3*env*g_ch2);
Out.ar(out.[2],sig3*env*g_ch3);Out.ar(out.[3],sig3*env*g_ch4);
Out.ar(out.[4],sig3*env*g_ch5);Out.ar(out.[5],sig3*env*g_ch6);
Out.ar(out.[6],sig3*env*g_ch7);Out.ar(out.[7],sig3*env*g_ch8);
Out.ar(out.[8],sig3*env*g_ch9);Out.ar(out.[9],sig3*env*g_ch10);
Out.ar(out.[10],sig3*env*g_ch11);Out.ar(out.[11],sig3*env*g_ch12);
Out.ar(out.[12],sig3*env*g_ch13);Out.ar(out.[13],sig3*env*g_ch14);
Out.ar(out.[14],sig3*env*g_ch15);Out.ar(out.[15],sig3*env*g_ch16);
Out.ar(out.[16],sig3*env*g_ch17);Out.ar(out.[17],sig3*env*g_ch18);
Out.ar(out.[18],sig3*env*g_ch19);Out.ar(out.[19],sig3*env*g_ch20);
Out.ar(out.[20],sig3*env*g_ch21);Out.ar(out.[21],sig3*env*g_ch22);
Out.ar(out.[22],sig3*env*g_ch23);Out.ar(out.[23],sig3*env*g_ch24);
Out.ar(out.[24],sig3*env*g_ch25);Out.ar(out.[25],sig3*env*g_ch26);
Out.ar(out.[26],sig3*env*g_ch27);Out.ar(out.[27],sig3*env*g_ch28);
Out.ar(out.[28],sig3*env*g_ch29);Out.ar(out.[29],sig3*env*g_ch30);Out.ar(out.[30],sig3*env*g_ch31);
)

}).add;
);
1.wait;
/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
(
(

({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;	~r2=0;
(
~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
(
~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];
3.do{
~x=bank.collect{
m1=m1+1;
b=Spherical(beat,~azr.[m1],~elr.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
c=Spherical(beat,~azr.[m2],~elr.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
d=Spherical(beat,~azr.[m3],~elr.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };
bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
~dur=~dur++~dur1++~dur2++~dur3;
)}.value);
);

~gain=1;~drive=0;~c=0;~attack=0.01;~decay=1;~sc=1;
~incr1=0;~incr2=0;~ssc=1;~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);
~incr=0;~ssc=26;~mix=0;
~seq= Pseq(~dur ,inf).asStream;
TempoClock.default.tempo_(0.01);

~pattern = Pdef(\1,
Pbind(\instrument, \synth,\dur, ~seq,\gain,
Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },
\c, Pfunc { ~c },\mix, Pfunc{~mix},
\az, Pseries(0, Pfunc{~incr1}, inf).collect(_.wrap(pi.neg, pi)).asStream,
\el, Pseries(0, Pfunc{~incr2}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)).asStream,
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern.play;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size,sk,compass,n,scl,r;
size=700; sk=(size/30); n=(2pi/9).neg; scl=(size/4); r=2;
w = Window("synthf", Rect(50, 50, size, size)).front;
~vw = UserView(w, w.view.bounds).drawFunc_({ ~img_print.drawInRect(~vw.bounds)});


compass=10.collect{n=n+(2pi/10); (exp(Complex(0,1)*n)*scl)};
(
~sl1=Knob.new(~vw, Rect.aboutPoint((compass.[0].real+(size/r)) @ (compass.[0].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,16256).round(1).asInteger.postln;
~sc=value;
});
);
(
~sl2=Knob.new(~vw, Rect.aboutPoint((compass.[1].real+(size/r)) @ (compass.[1].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,(16256*2).neg,(16256*2)).round(1).asInteger.postln;
~drive=value;
});
);
(
~sl3=Knob.new(~vw, Rect.aboutPoint((compass.[2].real+(size/r)) @ (compass.[2].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.01,4).postln;
~attack=value;
});
);
(
~sl4=Knob.new(~vw, Rect.aboutPoint((compass.[3].real+(size/r)) @ (compass.[3].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,~note).round(1).asInteger.postln;
~ssc=value;
});
);
(
~sl5=Knob.new(~vw, Rect.aboutPoint((compass.[4].real+(size/r)) @ (compass.[4].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0,16256*3).round(1).asInteger.postln;
~c=value;
});
);
(
~sl6=Knob.new(~vw, Rect.aboutPoint((compass.[5].real+(size/r)) @ (compass.[5].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,8).postln;
~decay=value;
});
);
(
~sl7=Knob.new(~vw, Rect.aboutPoint((compass.[6].real+(size/r))@ (compass.[6].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1-(1/~gold),28*~gold).postln;
TempoClock.default.tempo_(value);
});
);
(
~sl8=Knob.new(~vw, Rect.aboutPoint((compass.[7].real+(size/r))@ (compass.[7].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,2pi-(2pi/~gold)).round((2pi/992).degrad).postln;
~incr1=value;
});
);
(
~sl9=Knob.new(~vw, Rect.aboutPoint((compass.[8].real+(size/r))@ (compass.[8].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.degrad,pi-(pi/~gold)).round((pi/992).degrad).postln;
~incr2=value;
});
);
(
~sl10=Knob.new(~vw, Rect.aboutPoint((compass.[9].real+(size/r))@ (compass.[9].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,1).postln;
~mix=value;
});
)
}.defer
		));
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
