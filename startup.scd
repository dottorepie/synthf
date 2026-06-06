///Quarks.install("MathLib");
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*64;
s.options.blockSize = 64;
s.options.maxNodes = 8192*2;
Buffer.freeAll;
Window.closeAll;
s.makeGui(w);
//s.meter;
//s.freqscope;
s.scope;
);
~img_print = Image.open("/Users/rohifes/Documents/Literary/Portfolio/SUPERCOLLIDER/2026/synth/image1.jpg");///////////////paste image image1.jpg
s.waitForBoot{
Tdef(\drone, {
//~controlBus = Bus.control(s, 1);

////////////////////////////////////////////////////////////////////////////////////////// wavetable, scales, space,timbre///////////////////////////////////////
(
{
var az1=0,el1=0,az2=0,el2=0,angle=0;
var silver_r=(1+2.sqrt), g=((1+5.sqrt)/2), azimuth, elevation;

~az=[]; ~el=[];

32.do{
    azimuth = 32.collect{
        az1 = (az1 + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);
        el1 = (el1 + (pi-(pi/g))).wrap((pi/2).neg,(pi/2));
        (az1 + angle).wrap(pi.neg,pi)
    };

    elevation = 32.collect{
        az2 = (az2 + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);
        el2 = (el2 + (pi-(pi/g))).wrap((pi/2).neg,(pi/2));
        (el2 + angle).wrap((pi/2).neg,(pi/2))
    };

    angle = (angle + (2pi-(2pi/silver_r))).wrap(pi.neg,pi);

    ~az = ~az ++ azimuth;
    ~el = ~el ++ elevation;

    az1=0; el1=0;
    az2=0; el2=0;
};
}.value;

~vertices = 1024;

{
var nn=1.neg, n=0;
var difaz, difel;

difaz = ~vertices.collect{
    nn = nn + 1;
    ~az.[nn]
};

nn = 1.neg;

difel = ~vertices.collect{
    nn = nn + 1;
    ~el.[nn]
};

~cx = [];
~cy = [];
~cz = [];

~vertices.do{
    var az, el;
    var x, y, z;

    az = difaz.[n];
    el = difel.[n];

    // explicit spherical -> cartesian (radius = 1)
    x = cos(el) * cos(az);
    y = cos(el) * sin(az);
    z = sin(el);

    ~cx = ~cx ++ x;
    ~cy = ~cy ++ y;
    ~cz = ~cz ++ z;

    n = n + 1;
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


/////////////////////////////////////////////////////////////////////////////////////////////////////sound
(
SynthDef.new(\synth,{
arg gain=1,lowend=20,s_size=1,room=1,drive=0,
c=0,az=0,el=0,dicay=0.5,attack=0.01,sc=20,ssc=1,mix=0,
busArray = #[0,1,2,3,4,5,6,7,8,9,10,11];
var fund,fu=32,n=0,mod_x,mod_y,mod_z,phasex,phasey,phasez,low=0;
var freq1,freq2,freq3,amp1,amp2,amp3,sig1,sig2,sig3,heavy;
var b_x,b_y,b_z,polytope,env,expansion,sph1,sph2,xx,yy,zz;
var g_ch1,g_ch2,g_ch3,g_ch4,s1,s2,s3,s4,a1,a2,a3,a4,mp,mps,mpf,px,py,pz,ptheta,pphi;
var s_x,s_y,s_z,threshold,c1,c2,c3,mp_x,mp_y,mp_z,mps_x,mps_y,mps_z,mpf_x,mpf_y,mpf_z;

s1=Rand(0, ~vertices-1).round(1).asInteger;s2=Rand(0, ~vertices-1).round(1).asInteger;
s3=Rand(0, ~vertices-1).round(1).asInteger;s4=Rand(0, ~vertices-1).round(1).asInteger;

env=EnvGen.ar(Env.perc(attack,dicay,gain),doneAction:2);

expansion=2.pow(c.lag(0.01)/16256);
fund=(fu*(9/8))*expansion;
heavy=2.pow(drive.lag(0.01)/16256);

xx = (~vertices * cos(el) * cos(az)).round(1).asInteger.abs;
yy = (~vertices * cos(el) * sin(az)).round(1).asInteger.abs;
zz = (~vertices * sin(el)).round(1).asInteger.abs;
px=Select.kr(xx,~cx);
py=Select.kr(yy,~cy);
pz=Select.kr(zz,~cz);

ptheta=atan2(py,px);
pphi=atan2(pz,(px.squared+py.squared).sqrt);

///osc
mp_x = sc  * cos(pphi) * cos(ptheta);
mp_y = sc  * cos(pphi) * sin(ptheta);
mp_z = sc  * sin(pphi);

mps_x = ssc * cos(pphi) * cos(ptheta);
mps_y = ssc * cos(pphi) * sin(ptheta);
mps_z = ssc * sin(pphi);

mpf_x = cos(pphi) * cos(ptheta);
mpf_y = cos(pphi) * sin(ptheta);
mpf_z = sin(pphi);

b_x=2.pow(mpf_x.round(1)/16256);
b_y=2.pow(mpf_y.round(1)/16256);
b_z=2.pow(mpf_z.round(1)/16256);
s_x=2.pow(Select.kr(mps_x.round(1).asInteger.abs,~scale).asInteger /12);
s_y=2.pow(Select.kr(mps_y.round(1).asInteger.abs,~scale).asInteger /12);
s_z=2.pow(Select.kr(mps_z.round(1).asInteger.abs,~scale).asInteger /12);

mod_x=mpf_x;
mod_y=mpf_y;
mod_z=mpf_z;
//for linear phase mapping use linlin
//for compresse exp smoother maping with more energe towards similar values use complex
//for rational relations between phases and symmetry matrices use atan2 relation insteadof maping
//here since signal is wavefield ratio phases with more sidebands and matrice symmetries may be usefull
//phasex=(Complex(1,mod_x).theta*2);
//phasey=(Complex(1,mod_y).theta*2);
//phasez=(Complex(1,mod_z).theta*2);
phasex=atan2(mod_x,mod_y);
phasey=atan2(mod_y,mod_z);
phasez=atan2(mod_z,mod_x);

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

////distortion rectifier
sig1=((((SinOsc.ar(freq1*4,phase:phasex,mul:amp1/4)).abs+(amp1))*
(SinOsc.ar(freq1*2,phase:phasex,mul:amp1/2))).abs+(amp1))*c1;
sig2=((((SinOsc.ar(freq2*4,phase:phasey,mul:amp2/4)).abs+(amp2))*
(SinOsc.ar(freq2*2,phase:phasey,mul:amp2/2))).abs+(amp2))*c2;
sig3=((((SinOsc.ar(freq3*4,phase:phasez,mul:amp3/4)).abs+(amp3))*
(SinOsc.ar(freq3*2,phase:phasez,mul:amp3/2))).abs+(amp3))*c3;

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
g_ch1=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s1,~el)*a1)*cos(Select.kr(s1,~az)*a1))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s1,~el)*a1)*sin(Select.kr(s1,~az)*a1))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s1,~el)*a1));

g_ch2=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s2,~el)*a2)*cos(Select.kr(s2,~az)*a2))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s2,~el)*a2)*sin(Select.kr(s2,~az)*a2))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s2,~el)*a2));

g_ch3=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s3,~el)*a3)*cos(Select.kr(s3,~az)*a3))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s3,~el)*a3)*sin(Select.kr(s3,~az)*a3))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s3,~el)*a3));

g_ch4=
(sig1.abs.range(0.001,1)*cos(pphi)*cos(ptheta)*
 sig1.range(0.001,1)*cos(Select.kr(s4,~el)*a4)*cos(Select.kr(s4,~az)*a4))
+
(sig2.abs.range(0.001,1)*cos(pphi)*sin(ptheta)*
 sig2.range(0.001,1)*cos(Select.kr(s4,~el)*a4)*sin(Select.kr(s4,~az)*a4))
+
(sig3.abs.range(0.001,1)*sin(pphi)*
 sig3.range(0.001,1)*sin(Select.kr(s4,~el)*a4));

(
Out.ar(busArray.[0],LeakDC.ar(sig1*env));
Out.ar(busArray.[1],LeakDC.ar(sig2*env));
Out.ar(busArray.[2],LeakDC.ar(sig3*env));
)
///comment out the above parentheses and uncomment the below to use the synth on
///threefold speaker wavefield quad spat (12ch)/// to puput stereo sets (x,y) not use z channel as ouput (2,5,etc), sig3.
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////sequencer,pattern
(
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,d,n=0,bank=8,time=32.reciprocal,beat=1,r=0;
~r=0;~r1=0;~r2=0;

~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];

~dur1=[];~dur2=[];~dur3=[];
~dx=[];~dy=[];~dz=[];
~durx=[];~dury=[];~durz=[];
~dur=[];

bank.do{
    m1=m2=m3=~vertices.rand;

    ~x=1.collect{
        var az, el, x, y, z, xr, yr, zr;

        az = ~az.[m1];
        el = ~el.[m1];

        // spherical (beat = radius)
        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);

        // rotate (~r, ~r1, ~r2) approximated as axis rotations
        xr = x*cos(~r) - y*sin(~r);
        yr = x*sin(~r) + y*cos(~r);
        zr = z;

        xr = xr;
        2.pow(xr).round(time);
    };

    ~y=1.collect{
        var az, el, x, y, z, xr, yr, zr;

        az = ~az.[m2];
        el = ~el.[m2];

        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);

        xr = x*cos(~r1) - z*sin(~r1);
        zr = x*sin(~r1) + z*cos(~r1);

        yr = y;

        yr = yr;
        2.pow(yr).round(time);
    };

    ~z=1.collect{
        var az, el, x, y, z, xr, yr, zr;

        az = ~az.[m3];
        el = ~el.[m3];

        x = beat * cos(el) * cos(az);
        y = beat * cos(el) * sin(az);
        z = beat * sin(el);

        yr = y*cos(~r2) - z*sin(~r2);
        zr = y*sin(~r2) + z*cos(~r2);

        xr = x;

        zr = zr;
        2.pow(zr).round(time);
    };

    m1=1.neg; m2=1.neg; m3=1.neg;

    ~dx=~dx++~x;
    ~dy=~dy++~y;
    ~dz=~dz++~z;

    ~x=[]; ~y=[]; ~z=[];
    r=r+90.degrad;
};

n=0;
bank.do{ ~dur1=~dur1++~dx.[n]; n=n+1;}; n=0;
bank.do{ ~dur2=~dur2++~dy.[n]; n=n+1;}; n=0;
bank.do{ ~dur3=~dur3++~dz.[n]; n=n+1;}; n=0;

~dur=~dur++~dur1++~dur2++~dur3;

}).value;

~gain=1;~drive=0;~c=0;~attack=0.01;~decay=1;~s_size=1;~lowend=20;~room=0;
~incr1=0;~incr2=0;~sc=1;~gold=((1+5.sqrt)/2);~silver=(1+2.sqrt);
~incr=0;~ssc=26;~mix=0;
//~seq= Pseq([~dur.[0],Rest(~dur.[13.rand]),~dur.[1],Rest(~dur.[13.rand]),~dur.[2],Rest(~dur.[13.rand]),~dur.[3]] ,inf);
TempoClock.default.tempo_(0.01);

~pattern = Pdef(\1,
Pbind(\instrument, \synth,
\dur, Pseq(~dur ,inf),\s_size,Pfunc { ~s_size }, \lowend,Pfunc { ~lowend }, \room,Pfunc { ~room },
\gain,Pfunc { ~gain }, \sc, Pfunc { ~sc },\drive, Pfunc { ~drive },
\c, Pfunc { ~c },\mix, Pfunc{~mix},
\az, Pseries(0, Pfunc{~incr1}, inf).collect(_.wrap(pi.neg, pi)),
\el, Pseries(0, Pfunc{~incr2}, inf).collect(_.wrap(0.5pi.neg, 0.5pi)),
\attack,  Pfunc { ~attack }, \dicay, Pfunc { ~decay }, \ssc, Pfunc{~ssc};
));
~pattern.play;

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
TempoClock.default.tempo_(value);
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
value=obj.value.linexp(0,1,0.001,pi).postln;
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
)
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