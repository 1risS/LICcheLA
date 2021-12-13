// para poder usar los valores de OpenTrack
(
~rescale = {|valor, min, max|
	(valor*(max-min))+min
}
)

~rescale.(0.3,0,10)

//printea el puerto q escucha los msjs
NetAddr.langPort

//printea los msjs q llegan. Se desactiva con false.
OSCFunc.trace(false)

// un sinte
(
SynthDef.new(\sinte1, {|out=0, amp=0.5, y, x ampSine = 4|
	var por, mod, sig;

	por = SinOsc.ar(LinLin.kr(y,0,1,2,20),0,SinOsc.kr(ampSine));
	mod = SinOsc.kr(LinLin.kr(x, 0,1, 10, 200));
	sig = por * mod;

	sig = Pan2.ar(sig*amp);

	Out.ar(out,sig.cpsmidi.round.midicps)

}).add
)

Synth(\sinte1).play

//armo un cluster de ese sinte (podrían ser otros)
~sintes = 4.do.collect { Synth(\sinte1) };

// pongo la info OSC en uso
(
OSCdef(\hola, {|msg|
	// msg.postln
	var i, x, y;
	//ID del punto
	i = msg[1];
	// x
	x = msg[2];
	//y
	y = msg[3];
	[x,y].postln;
	~sintes[i-1].set(\x, x, \y, y, \ampSine, 0.125)
}, '/grid')
)

// para filtrar mensajes osc
(
f = { |msg, time, addr|
    if(msg[0] != '/status.reply') {
        "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};
thisProcess.addOSCRecvFunc(f);
);

// stop posting.
thisProcess.removeOSCRecvFunc(f);

// IP de Puppo y el puerto en que me escucha
m = NetAddr("127.0.0.1", 57120)

m.sendMsg('/hola', "weqwe")