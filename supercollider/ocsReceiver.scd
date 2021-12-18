ServerOptions.devices
Server.default.options.device = "Built-in Output"
s.options.outDevice = "Built-in Output"

(
s.options.outDevice = "AudioBox USB";
s.options.sampleRate = 48000;
)

s.boot;

// printea el puerto q escucha los msjs
NetAddr.langPort

// printea los msjs q llegan. Se desactiva con false.
OSCFunc.trace(false)

(
SynthDef(\sample, { |out=0, buf=0, pan=0, amp=1|
  var sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * Rand.new(0.85, 1.15), doneAction: Done.freeSelf);
  sig = Pan2.ar(Mix.ar(sig), pan) * amp;
    Out.ar(out, sig);
}).add;
)

// Carga samples y buffers
(
~samples = PathName.new(Platform.userHomeDir +/+ "/LICcheLA/palabrasFx/").files;
~buffers.do { |buf| buf.free };
~buffers = ~samples.collect { |sample| Buffer.read(s, sample.fullPath) };

~width = 8;
~height = 6;
~cx = ~width / 2;
~cy = ~height / 2;
~circleWidth = 1;

~routinePlaying = false;
~lastCircle = nil;

~rescale = { |valor, min, max|
  (valor*(max-min))+min
};

~handleCircleChange = { |circle|
  "Points moved to circle %".format(circle).postln;
  ~routine.stop;
  ~routine = Routine {
    loop {
      var samp = ~buffers.size.rand;
      "Play sample %".format(samp).postln;
      Synth(\sample, [\buf, ~buffers[samp], \pan, (1.0).rand2, \amp, (0.8).rand2]);
      (rrand(1, 2) * 0.125 * ((circle + 1) * 2)).yield;
    };
  }.play;
};

~maxKey = { |dict|
  var maxK, maxV;
  dict.keysValuesDo { |k, v|
    if (maxV.isNil) {
      maxV = v;
    };
    if (v >= maxV) {
      maxK = k;
      maxV = v;
    };
  };
  maxK;
};

// pongo la info OSC en uso
OSCdef(\id_x_y, { |msg|
  var numPoints, psDict, circleNum;

  numPoints = (msg.size / 3).trunc;
  psDict = ();


  //"msg: %".format(msg).postln;

  numPoints.do { |j|
    var x, y, u, v, t, dist, circ;

    x = msg[(j*3)+2];
    y = msg[(j*3)+3];

    // clamp entre 0 y 1, y luego lo llevo al ancho y alto real
    x = (x.max(0).min(1)) * ~width;
    y = (y.max(0).min(1)) * ~height;

    // calcula distancia del punto al centro del circulo (cx, cy)
    u = x - ~cx;
    v = y - ~cy;
    t = (u*u) + (v*v);
    dist = if (t > 0) { t.sqrt } { 0 };
    // discretiza la distancia para obtener los circulos
    circ = (dist / ~circleWidth).trunc;

    // [j, x, y, ~cx, ~cy, dist, circ].postln;

    // cuenta el punto en el diccionario
    if (psDict.includesKey(circ).not) {
      psDict[circ] = 1;
    } {
      psDict[circ] = psDict[circ] + 1;
    };
  };

  // psDict.postln;
  circleNum = ~maxKey.(psDict);
  [psDict, circleNum].postln;

  // Si el punto pasó a un nuevo circulo, dispara handler
  if (~lastCircle.notNil && circleNum != ~lastCircle) {
    ~handleCircleChange.(circleNum);
  };
  ~lastCircle = circleNum;

}, '/id_x_y');
)

// para detener rutina
(
~routine.stop;
~routinePlaying = false;
)

// IP de Puppo y el puerto en que me escucha
m = NetAddr("127.0.0.1", 57120)


// mensaje: circulo 3
(
m.sendMsg('/id_x_y',
  1, 0.46, 0.48,
  2, 0.1, 0.3,
  3, 0.1, 0.32,
  4, 0.11, 0.34,
  5, 0.99, 0.99,
);
)

// mensaje: circulo 0 (maxima densidad)
(
m.sendMsg('/id_x_y',
  1, 0.46, 0.48,
  2, 0.1, 0.3,
  3, 0.1, 0.32,
  4, 0.11, 0.34,
  5, 0.99, 0.99,
  6, 0.5, 0.5,
  7, 0.5, 0.5,
  8, 0.5, 0.5,
  9, 0.5, 0.5,
);
)

(
m.sendMsg('/id_x_y', 1, 0.01259833, 0.1704291, 2, 0.1180702, 0.006612175, 3, 0.4778707, 0.002194649, 4, 0.210063, 0.1046326, 5, 0.1020269, 0.3518159);
)