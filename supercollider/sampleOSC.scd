// cargo un sample, a futuro random.
(
p=Platform.userHomeDir +/+ "/LICcheLA/palabrasGlen/agua.wav";
b=Buffer.read(s,p);
)

~samples = PathName.new(Platform.userHomeDir +/+ "/LICcheLA/palabrasGlen").files;
~buffers = ~samples.collect { |sample| Buffer.read(s, sample.fullPath) };
// mezcla lista de buffers
~buffers = ~buffers.scramble;

// reproduce el primero
~buffers[0].play

~buffers[~buffers.size.rand].play

// lo disparo
(
~sample = SynthDef(\help_Buffer, { arg out = 0, bufnum;
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



