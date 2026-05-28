




///normal am  carrier
({
var carrier1,carrier2, signal1,signal2,wf_chan1,wf_chan2,fund=55,amp=1;
var phase_weight=[0,0.5pi],amp_weight=1;
///////////phase and amp weights on the wavefield channels define the beam direction and
///the wave node matrix nature
carrier1 = SinOsc.ar(40000,phase_weight.[0],amp_weight);
signal1 = SinOsc.ar(fund,phase_weight.[0],amp_weight);
carrier2 = SinOsc.ar(40000,phase_weight.[1],amp_weight);
signal2 = SinOsc.ar(fund,phase_weight.[1],amp_weight);
wf_chan1=(carrier1*(signal1+1))*amp;
wf_chan2=(carrier2*(signal2+1))*amp;
Out.ar(0,wf_chan1);
Out.ar(1,wf_chan2);
//////////shifting signal towards positive domain and mul to carrier
}.play
)





	