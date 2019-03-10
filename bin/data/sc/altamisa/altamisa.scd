// Altamisa Final //

s.waitForBoot{

	a = Array.fill(6, {arg i; Buffer.read(s, "~/altamisa/audios/altamisaCello/smpls/va"++(i+4)++".aif")});
	c =  Buffer.read(s, "~/altamisa/audios/altamisaCello/GeomFinal.wav");
	d =  Buffer.read(s, "~/altamisa/audios/altamisaCello/TASCAM_0287.wav");
	e =  Buffer.alloc(s, 44100*1, 1);
	
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
		var wp1, wp1b, wp2, wp3, wp4, wp2b, salidalim, salidag, salidamix, wps, input, ampin, rece, lag, reciproco, negativo, onsets, demanda, demanda2, salidout;
		rece = RecordBuf.ar(SoundIn.ar(0), e, loop: receloop, doneAction: 0);
		input = SoundIn.ar(0) * soundinamp;
		ampin = (Amplitude.ar(input) * regulador);
		lag = Lag.ar(ampin * 0.1, 0.5);
		reciproco  = ((1/(lag+0.0025)) * 0.05);
		negativo = (lag.neg) + 1;
		onsets = Onsets.kr(FFT(LocalBuf(512), SoundIn.ar(0)), umbral);
		demanda = Lag.kr(Demand.kr(onsets, 0, Dseq([0.3, 0.5, 0.5, 0.34667, 0.77889, 0.2223, 0.9666, 0.455, 0.221, 0.675,0.675,0.675,0.675,0.675,0.675,0.675,0.675,0.675,0.675].mirror, inf)), 1);
		demanda2 = Lag.kr(Demand.kr(onsets, 0, Dseq(Array.rand(12, 0.2, 0.99999).mirror, inf)), 2);
		// Electronica fija
		wp1 = Pan2.ar(Warp1.ar(1, x3, Lag.kr(pos3, lagdur3), pitch3, winsize3, -1, over3, randrat3, 4)) * Lag.kr(amp3, 4);
		wp1b = Pan2.ar(Warp1.ar(1, x3b, Lag.kr(pos3b, lagdur3b), pitch3b, winsize3b, -1, over3b, randrat3b, 4)) * Lag.kr(amp3b, 4);
		// electronica variable
		wp2 = (Pan2.ar(Warp1.ar(1, x2, demanda, pitch2, winsize2, -1, over2, randrat2, 4)) * Lag.kr(amp2, 2));
		wp2b = (Pan2.ar(Warp1.ar(1, x2b, demanda2, lag*0.25, winsize2b, -1, over2b, randrat2b, 4)) * Lag.kr(amp2b, 4)) * 1;
		// otras cosas
		// wp2 = (Pan2.ar(Warp1.ar(1, x2, lag, pitch2, winsize2, -1, Lag.kr(over2, lagover2), randrat2, 4)) * amp2) * reciproco;
		wp3 = Pan2.ar(Warp1.ar(1, x1, lag * 0.125, pitch1, winsize1, -1, over1, randrat1, 4)) * amp1;
		wp4 = (Pan2.ar(Warp1.ar(1, e, demanda2, pitch4, winsize4, -1, Lag.kr(over4, lagover4), randrat4, 4)) * amp4);
		//geom = Pan2.ar(PlayBuf.ar(2, c, BufRateScale.kr(c) * -0.125, MouseX.kr(0.1, 10), BufFrames.kr(c) * MouseY.kr(0, 1))).clip2(0.1)*ampgeom;
		wps = wp1 + wp1b + wp2 + wp3 + wp4 + wp2b;
			salidalim = DelayC.ar(wps, 0.01, 0.0001*0.5) * EnvFollow.ar(~out.ar, 1 - (0.0001 * SampleRate.ir).reciprocal).max(0.134377).reciprocal * 0.5!2;
			salidag = GVerb.ar(salidalim, 180, 5.85, 0.41, 0.19, 15, -3.dbamp, -5.dbamp, -7.dbamp, 180, 1) * 0.25;
			salidamix = salidalim + salidag;
			salidout = Compander.ar(salidamix, salidamix, 0.5, 1.0, 0.5, 0.01, 0.01);
		Out.ar(0, salidamix);
	}).add;
	
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
			buffer.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoAltamisa.wav",
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
			bufferana.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/ana1.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", bufferana]
			);
		};
		recordan.value(10);
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
			buffer.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoMejorana.wav",
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
			bufferana.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/ana2.wav",
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
			buffer.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/traigoAmansaguapo.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", buffer]
			);
		};
		recordfn.value(25);
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
			bufferana.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/ana3.wav",
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
			buffer.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/yrompesaraguey.wav",
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
			bufferana.write("~/Dropbox/altamisa/audios/altamisaCello/recop1/ana4.wav",
				"WAVE",
				"int16",
				//completionMessage: ["/b_free", bufferana]
			);
		};
		recordan.value(7);
	});

	n = NetAddr("127.0.0.1", 5512);

	~rutauno = Routine {
		1.do({
			"/////////////////////////////////////////".postln;
			"/////////////////PRIMERA/////////////////".postln;
			"/////////////////////////////////////////".postln;
			"Primer momento fijo de la electrónica".postln;
			~am = Synth(\altamisa, [\pos3, 0, \pitch3, 1, \winsize3, 0.2, \over3, 2, \randrat3, 0.4, \lagdur3, 4, \amp3, 0]);
			~am = Synth(\altamisa, [\pos3b, 0, \pitch3b, 1, \winsize3b, 0.2, \over3b, 2, \randrat3b, 0.4, \lagdur3b, 4, \amp3b, 0]);
			~am.set( \amp3, \amp3b, 0);
			0.1.wait;
			~am.set(\x3, a[0].bufnum, \amp3, 0.6, \pos3, 0.2, \lagdur3, 20, \pitch3, 0.5, \winsize3, 0.5, \over3, 12, \randrat3, 0.1);
			~am.set(\x3b, a[0].bufnum, \amp3b, 0.6, \pos3b, 0.2, \lagdur3b, 20, \pitch3b, 1, \winsize3b, 0.5, \over3b, 12, \randrat3b, 0.1);
			20.wait;
			~am.set(\x3, a[0].bufnum, \amp3, 0.6, \pos3, 0.23, \lagdur3, 10, \pitch3, 0.5, \winsize3, 0.5, \over3, 12, \randrat3, 0.1);
			~am.set(\x3b, a[0].bufnum, \amp3b, 0.6, \pos3b, 0.23, \lagdur3b, 10, \pitch3b, 1, \winsize3b, 0.5, \over3b, 12, \randrat3b, 0.1);
			// aquí podría ir la cosa que detona el análisis

			{			//			(
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
			};

			//si a es menor que b y que c entonces yes = a // en caso de que quisiera similitud.
			//si b es menor que a y que c
			// si b es menor que a y que b

			~manda.sendMsg('\yes', 2); // el index

			//)
			
			//	c //[ List[ 155.33421660256, 158.85525181972 ], List[ 122.95233852859 ] ]
			//d //[ 18, 16, 23 ]
			//c.flatten/100

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

		//_________________________________________________________ RUTA DOS _________________________________________________________________

	~rutados = Routine {
		1.do({

			"/////////////////////////////////////////".postln;
			"/////////////////SEGUNDA/////////////////".postln;
			"/////////////////////////////////////////".postln;
			"Segundo momento fijo de la electrónica".postln;

			// ~manda.sendMsg('\yes', [2, 3].choose);
			// ~manda.sendMsg('\yes', 2);

			~am.set(\amp3, 0.5, \pos3, 0.35, \lagdur3, 27, \pitch3, - 0.25, \over3, 12, \x2, a[0].bufnum, \amp2, 0.5, \pos2, 0.1, \pitch2, -1, \lagdur2, 27, \over2, 2);

			27.0.wait;

			~buf1 = Buffer.read(s, "/home/huachi/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoAltamisa.wav");
			//~am.set(\amp3, 0, \x2, d.bufnum, \amp2, 0.9, \over2, 8, \randrat3, 0.8, \pos2, 0.5, \winsize2, 0.05, \over3, 0.5);
			~am.set(\amp3, 0, \x2, d.bufnum, \amp2, 0.25, \winsize2, 0.5, \over2, 12, \lagdur2, 12, \pitch2, -1, \umbral, 0.25);

			~am.set(\amp3b, 0, \amp3, 0);
			"Primer segundo momento dinámico".postln;

			(14.0 + 1.0.rand).wait;

			// ~am.set(\amp3, 0, \x2, d.bufnum, \amp2, 0.9, \over2, 2, \randrat3, 0, \pos2, 0.95, \pitch2, 1, \regulador, 2000);
			~am.set(\amp3, 0, \x2, d.bufnum, \amp2, 0.25, \winsize2, 0.05, \over2, 14, \lagdur2, 12, \pitch2, -1, \umbral, 0.25);

			"Segundo segundo momento dinámico".postln;

			10.0.wait;

			"faltanCUATRO".postln;

			1.0.wait;

			"faltanTRES".postln;

			1.0.wait;

			"faltanDOS".postln;

			1.0.wait;

			"faltaUNO____Picaleya o se pica solo".postln;

			1.0.wait;

			~am.set(\amp2, 0);
			~manda.sendMsg('\bot3', 1);
			~y4y5y6OSC = OSCFunc({|msg|

				if(msg[1] == 4, {

					~am.set(\x3, a[0].bufnum, \amp1, 0, \pos3, 0.20, \lagdur1, 8, \pitch1, 1, \over1, 10, \x2, c.bufnum, \amp2, 0, \pos2, 0.29, \pitch3, -0.25, \lagdur2, 8, \over2, 0.125);
					"salio un y4".postln;
				});
				if(msg[1] == 5, {
					~am.set(\x3, d.bufnum, \amp1, 0, \pos3, 0.0001, \lagdur1, 8, \pitch1, 1, \over1, 10, \x2, c.bufnum, \amp2, 0, \pos2, 0.002, \pitch2, 1, \lagdur2, 8, \over2, 0.125);
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

	//_________________________________________________________ RUTA TRES ________________________________________________________________

	~rutatres = Routine {
		1.do({
			"/////////////////////////////////////////".postln;
			"/////////////////TERCERA/////////////////".postln;
			"/////////////////////////////////////////".postln;
			"Tercer momento fijo de la electrónica".postln;
			~manda.sendMsg('\yes', [4, 5, 6].choose);
			~am.set(\amp3, 0.25, \pos3, 1.0.rand, \lagdur3, 23, \over3, 12, \x2, d.bufnum, \amp2, 0.4, \pitch2, -1, \lagdur2, 23, \over2, 2); // pos a ver que pasa con la pos.
			23.0.wait;
			"Primer tercer momento dinámico".postln; // segundo análisis?
			~am.set(\amp3, 0, \x2, ~buf1.bufnum, \amp2, 1.5, \over3, 12, \randrat3, 0.1, \pos2, 0, \winsize2, 1);
			// ~am.set(\amp2b, 2, \amp1, 0); Esta es la línea. Cuál será el bueno?
			~am.set(\x3, a[0].bufnum, \amp3, 0, \amp3b, 0, \amp2, 0);
			~am.set(\x2b, a[0].bufnum, \amp2b, 2, \winsize2b, 0.1, \over2b, 8, \lagdur2b, 12, \pitch2b, 1, \umbralb, 0.5);

			// ~am2.set(\amp3, 0.5, \x2, ~buf2.bufnum, \over3, 4, \winsize1, 0.5, \regulador, 10); // Esto no es cuestión de apagarlo sino de liberarlo.
			(14.0 + 1.0.rand).wait;
			"el solo, a ver que sale".postln; /// Este es uno de los momentos más importantes
			~am.set(\amp3, 0, \x2, ~buf2.bufnum, \amp2, 1.5, \over3, 0.5, \randrat3, 0.2, \pos2, 0, \winsize3, 0.05);

			10.0.wait;
			"Segundo tercer momento dinámicO".postln;
			~am.set(\amp3, 0, \x2, ~buf2.bufnum, \amp2, 1.5, \over3, 0.5, \randrat3, 0.2, \pos2, 0, \winsize3, 0.05);
			~am.set(\amp2b, 1);

			10.0.wait;
			"faltanCUATRO".postln;
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


	//__________________________________________________________ RUTA CUATRO _____________________________________________________________

	~rutacuatro = Routine {
		1.do({
			"/////////////////////////////////////////".postln;
			"/////////////////CUARTA//////////////////".postln;
			"/////////////////////////////////////////".postln;
			"Cuarto momento fijo de la electrónica".postln;
			~manda.sendMsg('\yes', [7, 8].choose);
			~am.set(\amp3, 0.35, \pos3, 0.545, \lagdur3, 38, \over3, 12, \amp2, 0, \pos2, 0.1, \pitch2, -1, \lagdur2, 27, \over2, 2);
			/// ~am.set(\amp3, 0.35, \pos3, 0.35, \lagdur3, 27, \over3, 12, \amp2, 0, \pos2, 0.1, \pitch2, -1, \lagdur2, 27, \over2, 2); Este es el seguro, hay que armar uno salvaje :D
			28.0.wait; /// Creo que aquí se me fue la onda, revisar en vivo qué onda. Esto podría cambiarse, tanto en la rutina como en la partitura.
			"Primer cuarto momento dinámico".postln;
			~am.set(\amp3, 0, \amp2, 0, \x1, ~buf3.bufnum, \amp1, 0.5, \over1, 4, \randrat1, 0.2, \pos2, 0, \winsize1, 0.05);
			(14.0 + 1.0.rand).wait;
			"Segundo cuarto momento dinámico".postln;
			~am.set(\amp3, 0, \amp2, 0, \x1, ~buf3.bufnum, \amp1, 0.5, \over1, 10, \randrat1, 0.2, \pos2, 0, \winsize1, 0.05);
			~am.set(\amp3, 0, \amp2, 0, \x1, ~buf3.bufnum, \amp1, 0.5, \over1, 10, \randrat1, 0.2, \pos2, 0, \winsize1, 0.05);
			~am.set(\amp2b, 0);
			7.5.wait;
			"solodeCellodenuevo".postln;
			5.0.wait;
			"faltanCUATRO".postln;
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


	//_________________________________________________________ RUTA CINCO _______________________________________________________________

	~rutacinco = Routine {
		1.do({
			"/////////////////////////////////////////".postln;
			"/////////////////QUINTA//////////////////".postln;
			"/////////////////////////////////////////".postln;
			"Quinto momento fijo de la electrónica".postln;
			~am.set(\pos3, 0, \pitch3, 0.5, \winsize3, 0.2, \over3, 12, \randrat3, 0.2, \lagdur3, 24, \amp3, 0.5);
			14.0.wait;
			"Primer quinto momento dinámico".postln;
			~am.set(\receloop, 1, \amp4, 0.5, \over4, 12, \randrat4, 0.6);
			(20.0 + 2.0.rand).wait;
			"Segundo quinto momento dinámico".postln;
			~am.set(\receloop, 1, \amp4, 0.5, \over4, 0.5, \randrat4, 0, \lagover4, 10);
			10.0.wait;
			"solodeCompu".postln;
			17.0.wait;
			"faltanCUATRO".postln;
			1.0.wait;
			"faltanTRES".postln;
			1.0.wait;
			"faltanDOS".postln;
			1.0.wait;
			"faltaUNO____Picaleya o se pica solo".postln;
			1.0.wait;
			~am.set(\amp1, 0, \amp2, 0, \amp3, 0, \amp4, 0, \amp2b, 0, \amp3b, 0);

			"/////////////////////////////////////////".postln;
			"//////////////////FIN////////////////////".postln;
			"/////////////////////////////////////////".postln;
			0.5.wait;
			// s.quit; es necesario?
		})
	};
	
	m = NetAddr("127.0.0.1", 57120);

	~oscuno = OSCFunc({|msg|
		if (msg[1] == 1, {
			/// Si es uno, entonces
			m.sendMsg('\bot2', 0);m.sendMsg('\bot3', 0);m.sendMsg('\bot4', 0);m.sendMsg('\bot5', 0);
			~rutauno.play;
			~p1.next; ~pAn1.next;
	})}, '/bot1', recvPort: 57120);

	~oscdos = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf1 = Buffer.read(s, "~/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoAltamisa.wav");
			m.sendMsg('\bot1', 0);m.sendMsg('\bot3', 0);m.sendMsg('\bot4', 0);m.sendMsg('\bot5', 0);
			~rutados.play;
			~p2.next; ~pAn2.next;
		})}, '/bot2', recvPort: 57120);
	
	~osctres = OSCFunc({|msg|
		if (msg[1] == 1, {
			/// Si es uno, entonces
			~buf2 = Buffer.read(s, "~/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoMejorana.wav");
			m.sendMsg('\bot1', 0);m.sendMsg('\bot2', 0);m.sendMsg('\bot4', 0);m.sendMsg('\bot5', 0);
			~rutatres.play;
			~p3.next; ~pAn3.next})}, '/bot3', recvPort: 57120);
	
	~osccuatro = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf3 = Buffer.read(s, "~/Dropbox/altamisa/audios/altamisaCello/recop1/traigoAmansaguapo.wav");
			m.sendMsg('\bot1', 0);m.sendMsg('\bot2', 0);m.sendMsg('\bot3', 0);m.sendMsg('\bot5', 0);
			~rutacuatro.play;
			~p4.next; ~pAn4.next})}, '/bot4', recvPort: 57120);
	
	~osccinco = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf4 = Buffer.read(s, "/home/huachi/Dropbox/altamisa/audios/altamisaCello/recop1/yrompesaraguey.wav");
			m.sendMsg('\bot1', 0);m.sendMsg('\bot2', 0);m.sendMsg('\bot3', 0);m.sendMsg('\bot4', 0);
			~rutacinco.play;
			~p5.next; ~pAn5.next})}, '/bot5', recvPort: 57120);

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

}