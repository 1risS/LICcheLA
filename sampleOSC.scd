// cargo un sample, a futuro random.
(
p=Platform.userHomeDir +/+ "/Dirt-Samples/808/CB.wav";
b=Buffer.read(s,p);
)

// lo disparo
(
x = SynthDef(\help_Buffer, { arg out = 0, bufnum;
    Out.ar( out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
    )
}).play(s,[\bufnum, b]);
)

//sample en loop
(
x=SynthDef("PlayBufPlayer", {
    arg out=0, bufnum=0, rate=1, start=0, end=1;
    var snd,pos,frames;

    rate = rate*BufRateScale.kr(bufnum);
    frames = BufFrames.kr(bufnum);

    pos=Phasor.ar(
        rate:rate,
        start:start*frames,
        end:end*frames,
        resetPos:start*frames,
    );

    snd=BufRd.ar(
        numChannels:2,
        bufnum:bufnum,
        phase:pos,
        loop:0,
        interpolation:4,
    );
    Out.ar(out,snd)
}).play(s, [\out, 0, \bufnum, b]);
)



