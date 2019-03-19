//Altamisa

//Referencia 1

s.waitForBoot{

	// Referencia 2

	w = PathName.new("~/Dropbox/leviathan-altamisa/audio/".standardizePath);
	a = Array.fill(6, {arg i; Buffer.read(s, w.pathOnly++"smpls/va"++(i+4)++".aif")});
	c =  Buffer.read(s, w.pathOnly++"smpls/geom.wav");
	//d =  Buffer.read(s, w.pathOnly++"smpls/tascam1.wav");
	d = Array.fill(4, {arg i; Buffer.read(s, w.pathOnly++"smpls/tascam"++(i+1)++".wav")});
	e =  Buffer.alloc(s, 44100*1, 1);

	// Referencia 3

	SynthDef(\altamisa, {
		arg x1, x2 = b, x3 = ~va1, x2b, x3b, in, amp,

		pos2b = 0.0, pitch2b = 1, winsize2b = 0.2, over2b = 4, randrat2b = 0.4, lagdur2b = 4, amp2b = 0, lagover2b = 0,
		pos2 = 0.0, pitch2 = 1, winsize2 = 0.2, over2 = 4, randrat2 = 0.4, lagdur2 = 4, amp2 = 0, lagover2 = 0,
		pos3 = 0.0, pitch3 = 1, winsize3 = 0.2, over3 = 2, randrat3 = 0.4, lagdur3 = 0.1, amp3 = 0.1, lagover3 = 0,
		pos3b = 0.0, pitch3b = 1, winsize3b = 0.2, over3b = 12, randrat3b = 0.4, lagdur3b = 0.1, amp3b = 0.1, lagover3b = 0,

		pos1 = 0.0, pitch1 = 1, winsize1 = 0.2, over1 = 2, randrat1 = 0.4, lagdur1 = 0.1, amp1 = 0, lagover1 = 0,
		pitch4 = 1, winsize4 = 0.05, over4 = 2, randrat4 = 0.4, lagdur4 = 0.1, amp4 = 0, lagover4 = 0,
		ampgeom = 0, dust = 0.1,
		donb = 2, receloop = 0, soundinamp = 1, regulador = 2200, umbral = 0.25;

		var wp1, wp1b, wp2, wp3, wp4, wp2b, salidalim, salidag, salidamix, wps, input, ampin, rece, lag, reciproco, negativo, onsets, demanda, demanda2, reply;

		rece = RecordBuf.ar(SoundIn.ar(0), e, loop: receloop, doneAction: 0);
		input = SoundIn.ar(0) * soundinamp;
		ampin = (Amplitude.ar(input) * regulador);
		lag = Lag.ar(ampin * 0.1, 0.5);
		reply = SendReply.kr(Impulse.kr(20), '/reply', Lag.ar(ampin*0.1, 0.1));
		reciproco  = ((1/(lag+0.0025)) * 0.05);
		negativo = (lag.neg) + 1;
		onsets = Onsets.kr(FFT(LocalBuf(512), SoundIn.ar(0)), umbral);
		demanda = Lag.kr(Demand.kr(onsets, 0, Dseq([0.3, 0.5, 0.5, 0.34667, 0.77889, 0.2223, 0.9666, 0.455, 0.221, 0.675,0.675,0.675,0.675,0.675,0.675,0.675,0.675,0.675,0.675].mirror, inf)), 1);
		demanda2 = Lag.kr(Demand.kr(onsets, 0, Dseq(Array.rand(12, 0.2, 0.99999).mirror, inf)), 2);

		wp1 = Pan2.ar(Warp1.ar(1, x3, Lag.kr(pos3, lagdur3), pitch3, winsize3, -1, over3, randrat3, 4)) * Lag.kr(amp3, 4);
		wp1b = Pan2.ar(Warp1.ar(1, x3b, Lag.kr(pos3b, lagdur3b), pitch3b, winsize3b, -1, over3b, randrat3b, 4)) * Lag.kr(amp3b, 4);

		wp2 = (Pan2.ar(Warp1.ar(1, x2, demanda, pitch2, winsize2, -1, over2, randrat2, 4)) * Lag.kr(amp2, 2));
		wp2b = (Pan2.ar(Warp1.ar(1, x2b, demanda2, lag*0.25, winsize2b, -1, over2b, randrat2b, 4)) * Lag.kr(amp2b, 4)) * 1;

		// wp2 = (Pan2.ar(Warp1.ar(1, x2, lag, pitch2, winsize2, -1, Lag.kr(over2, lagover2), randrat2, 4)) * amp2) * reciproco;
		wp3 = Pan2.ar(Warp1.ar(1, x1, lag * 0.125, pitch1, winsize1, -1, over1, randrat1, 4)) * amp1;
		wp4 = (Pan2.ar(Warp1.ar(1, e, demanda2, pitch4, winsize4, -1, Lag.kr(over4, lagover4), randrat4, 4)) * amp4);

		wps = wp1 + wp1b + wp2 + wp3 + wp4 + wp2b + (input*0.5);

		//salidalim = DelayC.ar(wps*0.5, 0.01, 0.0001*0.5) * EnvFollow.ar(wps*0.5, 1 - (0.0001 * SampleRate.ir).reciprocal).max(0.134377).reciprocal * 0.5!2;
		//salidalim = Limiter.ar(wps * 2, 0.4, 0.01) * 1; /// Le trepe aquí.
		salidag = GVerb.ar(wps, 180, 5.85, 0.41, 0.19, 15, -3.dbamp, -5.dbamp, -7.dbamp, 180, 1) * [0.5, 0.5, 0.5, 0.5];
		//salidamix =  salidalim;
		Out.ar(0, salidag + wps);
	}).add;

	//Referencia 4

	Tdef(\cosa, {
		1.do({
			59.do{arg i;"0:".post; ((i+1)).postln;1.0.wait};
			59.do{arg i; "PRIMER MINUTO"; "1:".post;((i).postln);1.0.wait};
			59.do{arg i; "PRIMER MINUTO"; "2:".post;((i).postln);1.0.wait};
			59.do{arg i; "PRIMER MINUTO"; "3:".post;((i).postln);1.0.wait};
			59.do{arg i; "PRIMER MINUTO"; "4:".post;((i).postln);1.0.wait};
			59.do{arg i; "PRIMER MINUTO"; "5:".post;((i).postln);1.0.wait};
			59.do{arg i; "PRIMER MINUTO"; "6:".post;((i).postln);1.0.wait};
		})
	});

	//Referencia 5

	SynthDef(\entrada, {
		arg freq, duracion, amp = 1;
		var entrada;
		// entrada = SinOsc.ar(freq, 0, 0.1) * XLine.ar(1001, 1, duracion, add: -1, doneAction:2) / 1000;
		entrada = SoundIn.ar(0) * amp; // checar: volumenes, soundin e in y feedback.
		Out.ar(14, entrada!2);
	}).add;

	SynthDef(\grabadora, {
		arg buffer;
		var grabadora;
		grabadora = RecordBuf.ar(In.ar(14, 2), buffer, loop:0, doneAction:2);
	}).add;

	SynthDef(\grabadorana, {
		arg bufferana;
		var grabadora;
		grabadora = RecordBuf.ar(In.ar(14, 2), bufferana, loop:0, doneAction:2);
	}).add;

	//Referencia 6

	~p1 = Routine({
		var recordfn = {arg duracion;
			var server = Server.local;
			var buffer = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadora, [\buffer, buffer]);
			});
			duracion.wait;
			buffer.write(w.pathOnly++"mstrs/yotraigoAltamisa.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", buffer]
			);
		};
		recordfn.value(30);
	});

	~pAn1 = Routine({
		var recordan = {arg duracion;
			var server = Server.local;
			var bufferana = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadorana, [\bufferana, bufferana]);
			});
			duracion.wait;
			bufferana.write(w.pathOnly++"mstrs/ana1.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", bufferana]
			);
		};
		recordan.value(7);
	});

	~p2 = Routine({
		var recordfn = {arg duracion;
			var server = Server.local;
			var buffer = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadora, [\buffer, buffer]);
			});
			duracion.wait;
			buffer.write(w.pathOnly++"mstrs/yotraigoMejorana.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", buffer]
			);
		};
		recordfn.value(30);
	});

	~pAn2 = Routine({
		var recordan = {arg duracion;
			var server = Server.local;
			var bufferana = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadorana, [\bufferana, bufferana]);
			});
			duracion.wait;
			bufferana.write(w.pathOnly++"mstrs/ana2.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", bufferana]
			);
		};
		recordan.value(7);
	});


	~p3 = Routine({
		var recordfn = {arg duracion;
			var server = Server.local;
			var buffer = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadora, [\buffer, buffer]);
			});
			duracion.wait;
			buffer.write(w.pathOnly++"mstrs/traigoAmansaguapo.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", buffer]
			);
		};
		recordfn.value(20);
	});

	~pAn3 = Routine({
		var recordan = {arg duracion;
			var server = Server.local;
			var bufferana = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadorana, [\bufferana, bufferana]);
			});
			duracion.wait;
			bufferana.write(w.pathOnly++"mstrs/ana3.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", bufferana]
			);
		};
		recordan.value(7);
	});


	~p4 = Routine({
		var recordfn = {arg duracion;
			var server = Server.local;
			var buffer = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadora, [\buffer, buffer]);
			});
			duracion.wait;
			buffer.write(w.pathOnly++"mstrs/yrompesaraguey.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", buffer]
			);
		};
		recordfn.value(22);
	});

	~pAn4 = Routine({
		var recordan = {arg duracion;
			var server = Server.local;
			var bufferana = Buffer.alloc(server, server.sampleRate * duracion, 2);
			server.sync;
			server.makeBundle (func: {
				var player = Synth(\entrada, [ \duracion, duracion]);
				var recorder = Synth.after(player, \grabadorana, [\bufferana, bufferana]);
			});
			duracion.wait;
			bufferana.write(w.pathOnly++"mstrs/ana4.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", bufferana]
			);
		};
		recordan.value(7);
	});

	//Referencia 7

	~rutauno = Routine {
		1.do({

			"/////////////////PRIMERA/////////////////".postln;
			"Primer momento fijo de la electrónica".postln;

			~am = Synth(\altamisa, [\pos3, 0, \pitch3, 1, \winsize3, 0.2, \over3, 2, \randrat3, 0.4, \lagdur3, 4, \amp3, 0, \pos3b, 0, \pitch3b, 1, \winsize3b, 0.2, \over3b, 2, \randrat3b, 0.4, \lagdur3b, 4, \amp3b, 0]);
			//~am = Synth(\altamisa, [\pos3, 0, \pitch3, 1, \winsize3, 0.2, \over3, 2, \randrat3, 0.4, \lagdur3, 4, \amp3, 0]);
			//~am = Synth(\altamisa, [\pos3b, 0, \pitch3b, 1, \winsize3b, 0.2, \over3b, 2, \randrat3b, 0.4, \lagdur3b, 4, \amp3b, 0]);
			~am.set( \amp3, \amp3b, 0);

			0.1.wait;

			~am.set(\x3, a[0].bufnum, \amp3, 0.6, \pos3, 0.2, \lagdur3, 20, \pitch3, 0.5, \winsize3, 0.5, \over3, 12, \randrat3, 0.1);
			~am.set(\x3b, a[0].bufnum, \amp3b, 0.6, \pos3b, 0.2, \lagdur3b, 20, \pitch3b, 1, \winsize3b, 0.5, \over3b, 12, \randrat3b, 0.1);

			20.wait;

			~am.set(\x3, a[0].bufnum, \amp3, 0.6, \pos3, 0.23, \lagdur3, 10, \pitch3, 0.5, \winsize3, 0.5, \over3, 12, \randrat3, 0.1);
			~am.set(\x3b, a[0].bufnum, \amp3b, 0.6, \pos3b, 0.23, \lagdur3b, 10, \pitch3b, 1, \winsize3b, 0.5, \over3b, 12, \randrat3b, 0.1);

			// por aqui va una referencia 8

			10.wait;
			
			~am.set(\x3, a[0].bufnum, \amp3, 0.6, \pos3, 0.24, \lagdur3, 8, \pitch3, 0.5, \winsize3, 0.5, \over3, 12, \randrat3, 0.1);
			~am.set(\x3b, a[0].bufnum, \amp3b, 0.6, \pos3b, 0.24, \lagdur3b, 15, \pitch3b, 1, \winsize3b, 0.5, \over3b, 12, \randrat3b, 0.1);

			6.0.wait;

			"Primer primer momento dinámico".postln;
			
			~am.set(\x3, a[0].bufnum, \amp3, 0, \amp3b, 0);
			~am.set(\x2, a[0].bufnum, \amp2, 0.7, \winsize2, 0.05, \over2, 8, \lagdur2, 12, \pitch2, 1, \umbral, 0.5);

			(14.0 + 1.0.rand).wait;

			"Segundo primer momento dinámico".postln;

			~am.set(\x2, a[0].bufnum, \amp2, 0.7, \winsize2, 0.5, \over2, 8, \lagdur2, 12, \pitch2, 1, \umbral, 0.25);

			10.0.wait;

			"faltanCUATRO".postln;

			1.0.wait;

			"faltanTRES".postln;

			1.0.wait;

			"faltanDOS".postln;

			1.0.wait;

			"faltaUNO____Picaleya o se pica solo".postln;

			1.0.wait;

			~manda.sendMsg('\bot2', 1);

			~y2y3OSC = OSCFunc({|msg|

				if(msg[1] == 2, {

					~am.set(\x3, a[0].bufnum, \amp1, 0, \pos1, 0.24, \lagdur1, 8, \pitch1, 2, \over1, 10, \x2, a[0].bufnum, \amp2, 0, \pos2, 0.729, \pitch3, 1, \lagdur2, 8, \over2, 0.125);
					"salio un y2".postln;

				});

				if(msg[1] == 3, {

					~am.set(\x3, a[2].bufnum, \amp1, 0, \pos1, 0.24, \lagdur1, 8, \pitch1, 2, \over1, 10, \x2, a[2].bufnum, \amp2, 0, \pos2, 0.729, \pitch3, 2, \lagdur2, 12, \over2, 0.125);
					"salio un y3".postln;

				});

			}, '\yes', recvPort: 57120);

			1.0.wait;

		})
	};

	~rutados = Routine {
		1.do({

			"/////////////////SEGUNDA/////////////////".postln;
			"Segundo momento fijo de la electrónica".postln;

			// ~manda.sendMsg('\yes', [2, 3].choose);
			~manda.sendMsg('\yes', 2);

			"primer mensaje a mini-orbit".postln;

			OSCdef(\reply, {|msg|	
				var data = msg[3];	   
				//msg.postln;
				~ofx.sendMsg("\opacity", data.linlin(0.0, 1.0, 0.0, 230.0));
			}, '/reply');

			~ofx.sendMsg("\vload", 1, [4, 5, 6].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(100), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [7, 8, 9].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-100), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [1, 2, 3].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 100.rand2, 0);

			~am.set(\amp3, 0.5, \pos3, 0.35, \lagdur3, 27, \pitch3, - 0.25, \over3, 12, \x2, a[0].bufnum, \amp2, 0.5, \pos2, 0.1, \pitch2, -1, \lagdur2, 27, \over2, 2);

			27.0.wait;

			"segundo mensaje a mini-orbit".postln; 

			~ofx.sendMsg("\vload", 1, [1, 2, 3].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [4, 5, 6].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [7, 8, 9].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 100.rand2, 0);

			~buf1 = Buffer.read(s, w.pathOnly++"mstrs/yotraigoAltamisa.wav");
			//~am.set(\amp3, 0, \x2, d[[0, 1, 2, 3].choose].bufnum, \amp2, 0.9, \over2, 8, \randrat3, 0.8, \pos2, 0.5, \winsize2, 0.05, \over3, 0.5);
			~am.set(\amp3, 0, \x2, d[[0, 1, 2, 3].choose].bufnum, \amp2, 0.25, \winsize2, 0.5, \over2, 12, \lagdur2, 12, \pitch2, -1, \umbral, 0.25);

			~am.set(\amp3b, 0, \amp3, 0);
			"Primer segundo momento dinámico".postln;

			(14.0 + 1.0.rand).wait;

			~ofx.sendMsg("\vload", 1, [7, 8, 9].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(300), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [1, 2, 3].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-300), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [4, 5, 6].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			// ~am.set(\amp3, 0, \x2, d[[0, 1, 2, 3].choose].bufnum, \amp2, 0.9, \over2, 2, \randrat3, 0, \pos2, 0.95, \pitch2, 1, \regulador, 2000);
			~am.set(\amp3, 0, \x2, d[[0, 1, 2, 3].choose].bufnum, \amp2, 0.25, \winsize2, 0.05, \over2, 14, \lagdur2, 12, \pitch2, -1, \umbral, 0.25);

			"Segundo segundo momento dinámico".postln;

			10.0.wait;

			"faltanCUATRO".postln;

			~ofx.sendMsg("\vload", 1, [1, 2, 3].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(300), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [4, 5, 6].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-300), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [7, 8, 9].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			1.0.wait;

			"faltanTRES".postln;

			1.0.wait;

			"faltanDOS".postln;

			~ofx.sendMsg("\vload", 1, [1, 2, 3].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [4, 5, 6].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [7, 8, 9].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			1.0.wait;

			"faltaUNO____Picaleya o se pica solo".postln;

			1.0.wait;

			~ofx.sendMsg("\vload", 1, [7, 8, 9].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(100), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [1, 2, 3].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-100), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [4, 5, 6].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			~am.set(\amp2, 0);
			~manda.sendMsg('\bot3', 1);
			~y4y5y6OSC = OSCFunc({|msg|

				if(msg[1] == 4, {

					~am.set(\x3, a[0].bufnum, \amp1, 0, \pos3, 0.20, \lagdur1, 8, \pitch1, 1, \over1, 10, \x2, c.bufnum, \amp2, 0, \pos2, 0.29, \pitch3, -0.25, \lagdur2, 8, \over2, 0.125);
					"salio un y4".postln;
				});
				if(msg[1] == 5, {
					~am.set(\x3, d[[0, 1, 2, 3].choose].bufnum, \amp1, 0, \pos3, 0.0001, \lagdur1, 8, \pitch1, 1, \over1, 10, \x2, c.bufnum, \amp2, 0, \pos2, 0.002, \pitch2, 1, \lagdur2, 8, \over2, 0.125);
					"salio un y5".postln;
				});
				if(msg[1] == 6, {
					"salio un y6".postln;
					~am.set(\x3, a[0].bufnum, \pos3, 0.33, \over1, 10, \amp1, 0.5, \lagdur1, 10, \pitch3, 1);
				});
			}, '\yes', recvPort: 57120);
			1.0.wait;
		})
	};

	~rutatres = Routine {
		1.do({
			"/////////////////TERCERA/////////////////".postln;
			"Tercer momento fijo de la electrónica".postln;
			~manda.sendMsg('\yes', [4, 5, 6].choose);
			~am.set(\amp3, 0.25, \pos3, 1.0.rand, \lagdur3, 23, \over3, 12, \x2, d[[0, 1, 2, 3].choose].bufnum, \amp2, 0.4, \pitch2, -1, \lagdur2, 23, \over2, 2); // pos a ver que pasa con la pos.

			~ofx.sendMsg("\vload", 1, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			23.0.wait;
			"Primer tercer momento dinámico".postln; // segundo análisis?
			~am.set(\amp3, 0, \x2, ~buf1.bufnum, \amp2, 1.5, \over3, 12, \randrat3, 0.1, \pos2, 0, \winsize2, 1);
			// ~am.set(\amp2b, 2, \amp1, 0);
			~am.set(\x3, a[0].bufnum, \amp3, 0, \amp3b, 0, \amp2, 0);
			~am.set(\x2b, a[0].bufnum, \amp2b, 2, \winsize2b, 0.1, \over2b, 8, \lagdur2b, 12, \pitch2b, 1, \umbralb, 0.5);

			// ~am2.set(\amp3, 0.5, \x2, ~buf2.bufnum, \over3, 4, \winsize1, 0.5, \regulador, 10); // Esto no es cuestión de apagarlo sino de liberarlo.
			(14.0 + 1.0.rand).wait;
			"el solo, a ver que sale".postln; /// Este es uno de los momentos más importantes
			~am.set(\amp3, 0, \x2, ~buf2.bufnum, \amp2, 1.5, \over3, 0.5, \randrat3, 0.2, \pos2, 0, \winsize3, 0.05);
			~ofx.sendMsg("\vload", 3, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 3, rand(300), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 1, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(-300), 50.rand2, 0);
			~ofx.sendMsg("\vload", 2, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(100)-50, 50.rand2, 0);


			10.0.wait;
			"Segundo tercer momento dinámicO".postln;
			~am.set(\amp3, 0, \x2, ~buf2.bufnum, \amp2, 1.5, \over3, 0.5, \randrat3, 0.2, \pos2, 0, \winsize3, 0.05);
			~am.set(\amp2b, 2);

			10.0.wait;
			"faltanCUATRO".postln;

			~ofx.sendMsg("\vload", 2, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 2, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 3, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 1, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(100)-50, 50.rand2, 0);

			1.0.wait;
			"faltanTRES".postln;
			1.0.wait;
			"faltanDOS".postln;
			1.0.wait;
			"faltaUNO____Picaleya o se pica solo".postln;
			1.0.wait;
			~manda.sendMsg('\bot4', 1); ///// SEGUNDA - Desactivar esto en caso de electrónica en vivo
			~y7y8OSC = OSCFunc({|msg|
				if(msg[1] == 7, {
					~am.set(\x3, a[2].bufnum, \amp1, 0, \pos1, 0.24, \lagdur1, 8, \pitch1, -1, \over1, 10, \x2, c.bufnum, \amp2, 0, \pos2, 0.729, \pitch3, 0.5, \lagdur2, 8, \over2, 0.125);
					"salio un y7".postln;
				});
				if(msg[1] == 8, {
					~am.set(\x3, ~buf2.bufnum, \amp1, 0, \pos1, 0, \lagdur1, 8, \pitch1, 2, \over1, 10, \x2, c.bufnum, \amp2, 0, \pos2, 0.729, \pitch3, -0.25, \lagdur2, 8, \over2, 0.125, \over3, 4);
					"salio un y8".postln;
				});
			}, '\yes', recvPort: 57120);
			1.0.wait;
		})
	};

	~rutacuatro = Routine {
		1.do({
			"/////////////////CUARTA//////////////////".postln;
			"Cuarto momento fijo de la electrónica".postln;
			~manda.sendMsg('\yes', [7, 8].choose);
			~am.set(\amp3, 0.35, \pos3, 0.545, \lagdur3, 38, \over3, 12, \amp2, 0, \pos2, 0.1, \pitch2, -1, \lagdur2, 27, \over2, 2);
			/// ~am.set(\amp3, 0.35, \pos3, 0.35, \lagdur3, 27, \over3, 12, \amp2, 0, \pos2, 0.1, \pitch2, -1, \lagdur2, 27, \over2, 2);
			
			~ofx.sendMsg("\vload", 1, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(200), 100.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-200), 100.rand2, 0);
			~ofx.sendMsg("\vload", 3, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 100.rand2, 0);

			28.0.wait;
			"Primer cuarto momento dinámico".postln;
			~am.set(\amp3, 0, \amp2, 0, \x1, ~buf3.bufnum, \amp1, 0.5, \over1, 4, \randrat1, 0.2, \pos2, 0, \winsize1, 0.05);
			
			~ofx.sendMsg("\vload", 3, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 3, rand(300), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 1, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(-300), 50.rand2, 0);
			~ofx.sendMsg("\vload", 2, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(100)-50, 50.rand2, 0);

			(14.0 + 1.0.rand).wait;
			"Segundo cuarto momento dinámico".postln;
			~am.set(\amp3, 0, \amp2, 0, \x1, ~buf3.bufnum, \amp1, 0.5, \over1, 10, \randrat1, 0.2, \pos2, 0, \winsize1, 0.05);
			~am.set(\amp3, 0, \amp2, 0, \x1, ~buf3.bufnum, \amp1, 0.5, \over1, 10, \randrat1, 0.2, \pos2, 0, \winsize1, 0.05);

			~ofx.sendMsg("\vload", 2, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 2, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 3, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 1, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(100)-50, 50.rand2, 0);


			7.5.wait;
			"solodeCellodenuevo".postln;

			~ofx.sendMsg("\vload", 1, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(100), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-100), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			5.0.wait;
			"faltanCUATRO".postln;

			~ofx.sendMsg("\vload", 2, [10, 11, 12].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 2, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 3, [13, 14, 15].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 1, [16, 17, 18].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(100)-50, 50.rand2, 0);

			1.0.wait;
			"faltanTRES".postln;
			1.0.wait;
			"faltanDOS".postln;
			1.0.wait;
			"faltaUNO____Picaleya o se pica solo".postln;
			1.0.wait;
			~manda.sendMsg('\bot5', 1); /////  Desactivar esto en caso de electrónica en vivo
			~am.set(\amp1, 0, \pos1, 0.2, \lagdur1, 20, \pitch1, 2, \over1, 10, \x2, a[0].bufnum, \amp2, 0, \pos2, 0.729, \pitch2, -1, \lagdur2, 27, \over2, 0.125, \x3, a[0].bufnum, \amp3, 0.5, \pos3, 0.2, \lagdur3, 20, \pitch3, 0.5, \winsize3, 0.5, \over3, 12, \randrat3, 0.1);
			1.0.wait;
		})
	};

	~rutacinco = Routine {
		1.do({
			"/////////////////QUINTA//////////////////".postln;
			"Quinto momento fijo de la electrónica".postln;
			~am.set(\pos3, 0, \pitch3, 0.5, \winsize3, 0.2, \over3, 12, \randrat3, 0.2, \lagdur3, 24, \amp3, 0.5);

 			~ofx.sendMsg("\vload", 1, [19, 20, 21, 22].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [23, 24, 25, 26].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [27, 28, 29, 30].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			24.0.wait;
			"Primer quinto momento dinámico".postln;
			~am.set(\receloop, 1, \amp4, 0.5, \over4, 12, \randrat4, 0.6);

			~ofx.sendMsg("\vload", 2, [19, 20, 21, 22].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 2, rand(300), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 3, [23, 24, 25, 26].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(-300), 50.rand2, 0);
			~ofx.sendMsg("\vload", 1, [27, 28, 29, 30].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(100)-50, 50.rand2, 0);

			(20.0 + 2.0.rand).wait;
			"Segundo quinto momento dinámico".postln;
			~am.set(\receloop, 1, \amp4, 0.5, \over4, 0.5, \randrat4, 0, \lagover4, 10);

			~ofx.sendMsg("\vload", 3, [19, 20, 21, 22].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 3, rand(100), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 1, [23, 24, 25, 26].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(-100), 50.rand2, 0);
			~ofx.sendMsg("\vload", 2, [27, 28, 29, 30].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(100)-50, 50.rand2, 0);

			10.0.wait;
			"solodeCompu".postln;

			~ofx.sendMsg("\vload", 1, [19, 20, 21, 22].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(200), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [23, 24, 25, 26].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-200), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [27, 28, 29, 30].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			17.0.wait;
			"faltanCUATRO".postln;

			~ofx.sendMsg("\vload", 1, [19, 20, 21, 22].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 1, rand(100), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 2, [23, 24, 25, 26].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 2, rand(-100), 50.rand2, 0);
			~ofx.sendMsg("\vload", 3, [27, 28, 29, 30].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(100)-50, 50.rand2, 0);

			1.0.wait;
			"faltanTRES".postln;
			1.0.wait;
			
			~ofx.sendMsg("\vload", 2, [19, 20, 21, 22].choose.asString++".mov");
			~ofx.sendMsg("\vpos", 2, rand(50), 50.rand2, 0);	
			~ofx.sendMsg("\vload", 3, [23, 24, 25, 26].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 3, rand(-50), 50.rand2, 0);
			~ofx.sendMsg("\vload", 1, [27, 28, 29, 30].choose.asString++".mov");	
			~ofx.sendMsg("\vpos", 1, rand(100)-50, 50.rand2, 0);

			"faltanDOS".postln;
			1.0.wait;
			"faltaUNO____Picaleya o se pica solo".postln;
			1.0.wait;
			
			~ofx.sendMsg("\vfree", 1);	
			~ofx.sendMsg("\vfree", 2);	
			~ofx.sendMsg("\vfree", 3);	

			~am.set(\amp1, 0, \amp2, 0, \amp3, 0, \amp4, 0, \amp2b, 0, \amp3b, 0);
			"//////////////////FIN////////////////////".postln;
			0.5.wait;
			// s.quit; es necesario?
		})
	};

	//Referencia 9

	~manda = NetAddr("127.0.0.1", 57120);
	~ofx = NetAddr("127.0.0.1", 5612);

	~oscuno = OSCFunc({|msg|
		if (msg[1] == 1, {
			/// Si es uno, entonces
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot4', 0);
			~manda.sendMsg('\bot5', 0);
			~rutauno.play;
			~p1.next; ~pAn1.next;
			//Tdef(\cosa).play;	
	})}, '/bot1', recvPort: 57120);

	/// SEGUNDA

	~oscdos = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf1 = Buffer.read(s, w.pathOnly++"mstrs/yotraigoAltamisa.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot4', 0);
			~manda.sendMsg('\bot5', 0);
			~rutados.play;
			~p2.next; ~pAn2.next})}, '/bot2', recvPort: 57120);

	/// TERCERA

	~osctres = OSCFunc({|msg|
		if (msg[1] == 1, {
			/// Si es uno, entonces
			~buf2 = Buffer.read(s, w.pathOnly++"mstrs/yotraigoMejorana.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot4', 0);
			~manda.sendMsg('\bot5', 0);
			~rutatres.play;
			~p3.next; ~pAn3.next})}, '/bot3', recvPort: 57120);

	/// CUARTA

	~osccuatro = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf3 = Buffer.read(s, w.pathOnly++"mstrs/traigoAmansaguapo.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot5', 0);
			~rutacuatro.play;
			~p4.next; ~pAn4.next})}, '/bot4', recvPort: 57120);

	/// QUINTA

	~osccinco = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf4 = Buffer.read(s, w.pathOnly++"mstrs/yrompesaraguey.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot4', 0);
			~rutacinco.play;
			~p5.next; ~pAn5.next})}, '/bot5', recvPort: 57120);

//n = NetAddr("127.0.0.1", 57120);
//n.sendMsg("/bot1", 1);
"
███╗   ███╗██╗███╗   ██╗██╗       ██████╗ ██████╗ ██████╗ ██╗████████╗    
████╗ ████║██║████╗  ██║██║      ██╔═══██╗██╔══██╗██╔══██╗██║╚══██╔══╝    
██╔████╔██║██║██╔██╗ ██║██║█████╗██║   ██║██████╔╝██████╔╝██║   ██║       
██║╚██╔╝██║██║██║╚██╗██║██║╚════╝██║   ██║██╔══██╗██╔══██╗██║   ██║       
██║ ╚═╝ ██║██║██║ ╚████║██║      ╚██████╔╝██║  ██║██████╔╝██║   ██║       
╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝       ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝   ╚═╝       
                                                                          
███████╗███╗   ██╗    ███████╗███████╗██████╗ ███████╗██████╗  █████╗     
██╔════╝████╗  ██║    ██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗██╔══██╗    
█████╗  ██╔██╗ ██║    █████╗  ███████╗██████╔╝█████╗  ██████╔╝███████║    
██╔══╝  ██║╚██╗██║    ██╔══╝  ╚════██║██╔═══╝ ██╔══╝  ██╔══██╗██╔══██║    
███████╗██║ ╚████║    ███████╗███████║██║     ███████╗██║  ██║██║  ██║    
╚══════╝╚═╝  ╚═══╝    ╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    
                                                                          
 ".postln

}

/*

	(
		var featurelist = [[MFCC, 10],[Loudness],[SpecCentroid],[SpecPcile, 0.95],[SpecPcile, 0.8],[SpecFlatness],[FFTCrest],[FFTCrest, 0, 2000], [FFTCrest, 2000, 10000],[FFTSpread],[FFTSlope],[SensoryDissonance],[Onsets,\rcomplex]];
		var files = ["/home/huachi/Dropbox/leviathan-altamisa/audio/smpls/ve7.aif","/home/huachi/Dropbox/leviathan-altamisa/audio/smpls/le1.wav", "/home/huachi/Dropbox/leviathan-altamisa/audio/smpls/le1.wav"];
		var comparisonmatrix;
		var audioanalysis;
		var score= 0.0;
		var numfit;
		var temp;
		var segmentsize= 10.0;   //Short Term Memory size
		{
			audioanalysis = files.collect{|filename,i|
				e = SCMIRAudioFile(filename,featurelist);
				e.extractFeatures();
			};
			numfit= audioanalysis.collect{|val| val.duration};
			numfit = (numfit/segmentsize).asInteger;
			numfit.postln;
			comparisonmatrix = Array.fill(files.size-1,{|i|
				var comparisons = List[];
				var audio1 = audioanalysis[i];
				var numfit1 = numfit[i];
				if((i+1) < (files.size)	) {
					for(i+1,files.size-1,{|j,count|
						var audio2 = audioanalysis[j];
						var numfit2 = numfit[j];
						("comparing"+i+"to"+j).postln;
						score= 0.0;
						numfit1.do{|segment1|
							var minval = 999999999999.9;
							//var minindex=0;
							var excerpt1,excerpt2,matrix;
							[\segment1, segment1].postln;
							excerpt1 = SCMIRAudioFile.newFromRange(audio1,segment1*segmentsize,(segment1+1)*segmentsize);
							numfit2.do{|segment2|
								[\segment2, segment2].postln;
								excerpt2 = SCMIRAudioFile.newFromRange(audio2,segment2*segmentsize,(segment2+1)*segmentsize);
								0.01.wait;
								matrix = excerpt1.similarityMatrix(2, 2, other:excerpt2);
								0.01.wait;
								//actually 6 either side in original frame terms
								d = matrix.dtw(3);
								//d.postln;
								if(d[0]<minval) {
									minval = d[0];
									//minindex = j;
								};
							};
							score = score + minval;
							score.postln;
						};
						comparisons.add(score/numfit1); // /(audio1.duration) //normalize scores relative to audio1 currently being compared to others, to get a similarity per block
					});
				};

				comparisons
			});

			c = comparisonmatrix;
			d = numfit;

		}.fork(SystemClock, stackSize:16384); //wait for me to finish

	)
	c //[ List[ 155.33421660256, 158.85525181972 ], List[ 122.95233852859 ] ]
	d //[ 18, 16, 23 ]
	c.flatten/100

	*/
