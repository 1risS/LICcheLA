(
s = Server.local;
s.waitForBoot({

SynthDef("shep",{
	arg amp=0.08, freq=440;
	var sig;
	sig = SinOsc.ar([freq,freq]);
	sig = sig*amp;
	Out.ar(0, sig);
}).add;


~playShep = {

	arg	speed=0.015,
			volume=0.5,
			direction=0,
			centerFreqShift=0;

	var	pat0,pat1,pat2,pat3,pat4,pat5,pat6,pat7,pat8,
			midiArray,ampArray;

	midiArray=(6,6.01..113.99);

	ampArray = Array.newClear(10800);
	(-5400..5399).do{
		arg val, index;
		ampArray[index]=1.000001.pow((val.pow(2).neg));
	};

	if(
		direction > 0,
		{midiArray},
		{midiArray = midiArray.reverse});

	midiArray = midiArray+centerFreqShift;

	pat0 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray,inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray,inf),]);

	pat1 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-1200),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
			],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-1200),inf),]);

	pat2 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-2400),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
			],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-2400),inf),]);

	pat3 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-3600),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-3600),inf),]);

	pat4 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-4800),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-4800),inf),]);

	pat5 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-6000),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-6000),inf),]);

	pat6 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-7200),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-7200),inf),]);

	pat7 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-8400),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-8400),inf),]);

	pat8 = Pmono(*[\shep,
		dur:speed,
		amp:
			Pseq(ampArray.rotate(-9600),inf) *
			Pseq([
				Pseg(Pseq([0,1],1),Pseq([1,0],1),\sine),
				Pseq([1],inf)
				],1) *
			volume,
		midinote:Pseq(midiArray.rotate(-9600),inf),]);

	Pspawner({
		arg sp;
		sp.par(pat0);
		sp.par(pat1);
		sp.par(pat2);
		sp.par(pat3);
		sp.par(pat4);
		sp.par(pat5);
		sp.par(pat6);
		sp.par(pat7);
		sp.par(pat8);
	}).play;
};
})
)


~playShep.(0.03, 0.75,  0,  0);

(
~playShep.(0.015, 0.24,  1,  0);
~playShep.(0.015, 0.24,  1,  3);
~playShep.(0.015, 0.24,  1,  7);
)

(
~playShep.(0.006,  0.122,  0,  -5.1);
~playShep.(0.017,  0.122,  0,   2.5);
~playShep.(0.035,  0.122,  0,   5.9);
~playShep.(0.043,  0.122,  0,   9.7);
~playShep.(0.012,  0.122,  0,   14.1);
~playShep.(0.025,  0.122,  0,   17.25);
~playShep.(0.075,  0.122,  0,   21.6);
~playShep.(0.051,  0.122,  0,   23.7);
)

(
~playShep.(0.005,  0.122,  1,  -5.5);
~playShep.(0.034,  0.122,  0,   22.7);
~playShep.(0.014,  0.122,  0,   1.83);
~playShep.(0.023,  0.122,  1,   2.4);
~playShep.(0.011,  0.122,  0,   2.5);
~playShep.(0.045,  0.122,  0,   11);
~playShep.(0.065,  0.122,  1,   17.1);
~playShep.(0.041,  0.122,  1,   5.7);
)