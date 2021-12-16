ServerOptions.devices

Server.default.options.device = "Built-in Output"

Server.default.reboot


(
SynthDef(\mic, { arg out=0, freq=440, w=0.5, r=1, d=1;
    var source;
	source = SoundIn.ar(0,1);

	source = FreeVerb(source, source, w, r, d);


        // write to the bus, adding to previous contents
        Out.ar(out, source);

}).add;
)

~mic = Synth(\mic)

~mic.set(\w, 0.5)

{SinOsc.ar(100)}.play