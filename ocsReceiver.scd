s.boot;

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

(
~width = 8;
~height = 6;
~cx = ~width / 2;
~cy = ~height / 2;
~circleWidth = 1;

~lastCircle = nil;

~handleCircleChange = { |i, circle|
	"Point % moved to circle %".format(i, circle).postln;
};

// pongo la info OSC en uso

OSCdef(\puntos, {|msg|
	// msg.postln
	var i, x, y, u, v, t, dist, circleNum;
	//ID del punto
	i = msg[1];
	// x
	x = msg[2];
	//y
	y = msg[3];

	x = x * ~width;
	y = y * ~height;

	u = x - ~cx;
	v = y - ~cy;
	t = (u*u) + (v*v);
	dist = if (t > 0) { t.sqrt } { 0 };
	circleNum = (dist / ~circleWidth).trunc;

	if (~lastCircle.notNil && circleNum != ~lastCircle) {
		~handleCircleChange.(i, circleNum);
	};
	~lastCircle = circleNum;

	// [i, x, y, dist, circleNum].postln;
	// [i, circleNum, dist].postln;
	// ~sintes[i-1].set(\x, x, \y, y, \ampSine, 0.125)
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

m.sendMsg('/grid', 1, 0.2, 0.3)