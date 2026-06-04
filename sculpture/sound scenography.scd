///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=3;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*64;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
s.meter;
//s.freqscope;
s.scope;
);
~img_print = Image.open("/Users/rohifes/Documents/Literary/Portfolio/SUPERCOLLIDER/2026/synth/image1.jpg");///////////////paste image image1.jpg
s.waitForBoot{
Tdef(\drone, {
//~controlBus = Bus.control(s, 1);

////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre///////////////////////////////////////
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
{
var  sph1,sph2,az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt),g=((1+5.sqrt)/2),mag1=1,mag2=1,azimuth,elevation;
~az=[];~el=[];

32.do{
azimuth=32.collect{
az1 = (az1+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
el1 = (el1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta;
};
elevation=32.collect{
az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
el2 = (el2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi;
};
angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;
az1=0;el1=0;az2=0;el2=0;
}
}.value;
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
var nn=2.neg;
~scale=~note.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
}.value;
);
);
~buff = Buffer.readChannel(s,"/Users/rohifes/Desktop/713353__klankbeeld__spring-river-village-9.wav",channels:0 );

/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,
c=0,az=0,el=0,dicay=0.5,attack=0.01,sc=20,ssc=1,mix=0,
busArray = #[0,1,2,3,4,5,6,7,8,9,10,11];
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps,mpf;
var threshold,c1,c2,c3,chain,buff,frames=1024,cp1,cp2,cp3;

s1=Rand(0, ~vertices-1).round(1).asInteger;s2=Rand(0, ~vertices-1).round(1).asInteger;
s3=Rand(0, ~vertices-1).round(1).asInteger;s4=Rand(0, ~vertices-1).round(1).asInteger;

xx=Spherical(~vertices,az,el).x.round(1).asInteger.abs;
yy=Spherical(~vertices,az,el).y.round(1).asInteger.abs;
zz=Spherical(~vertices,az,el).z.round(1).asInteger.abs;
polytope=Cartesian(Select.kr(xx,~cx),Select.kr(yy,~cy),Select.kr(zz,~cz));

///osc
mp=Spherical(sc,polytope.theta, polytope.phi);
mpf=Spherical(1,polytope.theta, polytope.phi);

b_x=2.pow(mp.x.round(1)/16256);
b_y=2.pow(mp.y.round(1)/16256);
b_z=2.pow(mp.z.round(1)/16256);

mod_x=mpf.x;
mod_y=mpf.y;
mod_z=mpf.z;
//for linear phase mapping use linlin
//for compressed exp smoother maping with more
///energy towards similar values use complex
//for rational relations between phases and
///symmetry matrices use atan2 relation instead
///of maping
//metaphorically linear is like vanishing point
//wavefield perspective
///complex is fisheye
//ratios is axonometric
//phasex=(Complex(1,mod_x).theta*2);
//phasey=(Complex(1,mod_y).theta*2);
//phasez=(Complex(1,mod_z).theta*2);
phasex=atan2(mod_x,mod_y);
phasey=atan2(mod_y,mod_z);
phasez=atan2(mod_z,mod_x);



amp1=b_x.reciprocal;
amp2=b_y.reciprocal;
amp3=b_z.reciprocal;

buff = PlayBuf.ar(1, ~buff.bufnum, BufRateScale.kr(~buff.bufnum), loop: 1, doneAction:0);

chain = FFT(LocalBuf(frames), buff);

c1 = PV_MagMul(chain, amp1);
c2 = PV_MagMul(chain, amp2);
c3 = PV_MagMul(chain, amp3);

cp1 = PV_PhaseShift(c1, phasex);
cp2 = PV_PhaseShift(c2, phasey);
cp3 = PV_PhaseShift(c3, phasez);

sig1=IFFT(cp1);
sig2=IFFT(cp2);
sig3=IFFT(cp3);

sig1=FreeVerb.ar(sig1,mix,room);
sig2=FreeVerb.ar(sig2,mix,room);
sig3=FreeVerb.ar(sig3,mix,room);

/////spat
/*a1=a2=a3=a4=1;
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
);*/

(
Out.ar(busArray.[0],LeakDC.ar(sig1*gain));
Out.ar(busArray.[1],LeakDC.ar(sig2*gain));
Out.ar(busArray.[2],LeakDC.ar(sig3*gain));
)
///comment out the above parentheses and uncomment the below to use the synth on
///threefold speaker wavefield quad spat (12ch)
/*(
Out.ar(busArray.[0],LeakDC.ar(sig1*env*g_ch1));
Out.ar(busArray.[1],LeakDC.ar(sig2*env*g_ch1));
Out.ar(busArray.[2],LeakDC.ar(sig3*env*g_ch1));
Out.ar(busArray.[3],LeakDC.ar(sig1*env*g_ch2));
Out.ar(busArray.[4],LeakDC.ar(sig2*env*g_ch2));
Out.ar(busArray.[5],LeakDC.ar(sig3*env*g_ch2));
Out.ar(busArray.[6],LeakDC.ar(sig1*env*g_ch3));
Out.ar(busArray.[7],LeakDC.ar(sig2*env*g_ch3));
Out.ar(busArray.[8],LeakDC.ar(sig3*env*g_ch3));
Out.ar(busArray.[9],LeakDC.ar(sig1*env*g_ch4));
Out.ar(busArray.[10],LeakDC.ar(sig2*env*g_ch4));
Out.ar(busArray.[11],LeakDC.ar(sig3*env*g_ch4));
)*/

}).add;
);
1.wait;
		~synth=Synth(\synth).register;
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////gui
(
{
var size,sk,compass,n,scl,r,ssk=20,scope1,scope2,scope3,scope4,meter;
size=700; sk=(size/30); n=(2pi/9).neg; scl=(size/4); r=2;
compass=10.collect{n=n+(2pi/10); (exp(Complex(0,1)*n)*scl)};

w = Window("synthf", Rect(50, 50, size*2, size)).front;
~vw = UserView(w, Rect(0,0,size,size)).drawFunc_({ ~img_print.drawInRect(~vw.bounds)});
~vw1 = UserView(w,Rect(size,0,size,size)).background_(Color.black);
~logView = ListView( ~vw1, Rect(0, 0, 40, 750))
.background_(Color.black).stringColor_(Color.white)
.font_(Font("Arial", 20))
.items_([]);
~logItems = List.new;
~log = { |msg| {~logItems.add(msg); if(~logItems.size > 200) { ~logItems.removeAt(0);  };
 ~logView.items_(~logItems.asArray); ~logView.value_(~logItems.size - 1); }.defer;};

scope1 = FreqScopeView(~vw1, Rect(sk+100+50,sk+ssk+30,  sk+350, sk+100));
scope1.active_(true);scope1.dbRange_(120);scope1.inBus_(0);scope1.freqMode_(0);
scope2 = FreqScopeView(~vw1, Rect(sk+100+50, sk+ssk+180,  sk+350, sk+100));
scope2.active_(true);scope2.dbRange_(120);scope2.inBus_(1);scope2.freqMode_(0);
scope3 = FreqScopeView(~vw1, Rect(sk+100+50, sk+ssk+330, sk+350, sk+100));
scope3.active_(true);scope3.dbRange_(120);scope3.inBus_(2);scope3.freqMode_(0);
(
~sl1=Knob.new(~vw, Rect.aboutPoint((compass.[0].real+(size/r)) @ (compass.[0].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,1,16256).round(1).asInteger.postln;
~sc=value;
~synth.set(\sc,value);
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
~synth.set(\drive,value);
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
TempoClock.default.tempo_(value);
~log.(value.asString);
});
);
(
~sl8=Knob.new(~vw, Rect.aboutPoint((compass.[7].real+(size/r))@ (compass.[7].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,pi.neg,pi);
~incr1=value;
~synth.set(\az,value);
~log.(value.asString);
});
);
(
~sl9=Knob.new(~vw, Rect.aboutPoint((compass.[8].real+(size/r))@ (compass.[8].imag+(size/r)), sk, sk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linlin(0,1,0.5pi.neg,0.5pi).postln;
~incr2=value;
~synth.set(\el,value);
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
~synth.set(\mix,value);
~log.(value.asString);
});
);
(
~sl01=Knob.new(~vw1, Rect.new(sk+sk+50+50+sk,sk+sk, sk+ssk, sk+ssk)).
background_(Color.black).action_({
arg obj;
var value;
value=obj.value.linexp(0,1,0.001,pi).postln;
~gain=value;
~synth.set(\gain,value);
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
~synth.set(\room,value);
~log.(value.asString);
});
)
}.defer
)
}); Tdef(\drone).play;
}
)






/////space symmetric, for music keys, timbre or vbap
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