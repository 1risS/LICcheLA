(
Ndef(\simpleRunningWater).fadeTime = 4;


Ndef(\simpleRunningWater, {
	var mod, freq, ampMod, src;

	mod = {LFNoise0.ar(170)}!2;

	freq = mod.linexp(-1, 1, \lowFreq.kr(400, 8), 2400).lag(0.01); //  * Line.kr(1, 0.01, 40);
	ampMod = 0.5 + mod.linlin(-1, 1, 0.5, 0).lag(0.1);

	ampMod = ampMod * AmpComp.ar(freq);

	src = LPF.ar(SinOsc.ar(
		freq,
		0.6,
		ampMod
	), 4000);

	// src * LFPulse.ar(10);
	src

})
)

Ndef(\simpleRunningWater).set(\lowFreq, 1000);
Ndef(\simpleRunningWater).xset(\lowFreq, 1000);
Ndef(\simpleRunningWater).gui

// random deep fryer. can turn in to rain, waves and other stuff.
// nice with multichannel iteration. Change number at "!2".
// volume compensation for high quality filter with "1/q.sqrt" for mul in BPF.
// variable "dist" for distortion, increasing can go loud, decrease "amp" if so.
// LFNoise1 with noisefreq,noisemul,noiseoffset gives it the wavy feel.

(
SynthDef(\friture, {
	arg amp=0.5, dist=2, dens=12, dustamp=1, offset=0, noisefreq=2, noisemul=2,
	noiseoffset=0, frq1=200, frq2=2500, rq1=0.5, rq2=0.1, out=0;

	var sig, env;

	sig = {BPF.ar((Dust2.ar(dens, dustamp, offset)*LFNoise1.ar(noisefreq,noisemul,noiseoffset)),rrand(frq1,frq2),q=rrand(rq1,rq2),1/q.sqrt)}!2;
	sig = (sig*dist).tanh*amp;


	Out.ar(out,sig);

	}).add;
)

y = Synth.new(\friture);
y.free;

(
y.set(\dens,161);
y.set(\amp,0.5);
y.set(\dist,1);
y.set(\rq1,0.2);
y.set(\rq2,0.4);
y.set(\frq1,193);
y.set(\frq2,191);
y.set(\noisefreq,0.5);
y.set(\noisemul,2);
y.set(\noiseoffset,(-2));
y.set(\out,0);
)