// Altamisa Final //

// Referencia 1. Encendido del servidor. Nota: para comparar matrices no es necesario usar el modo de tiempo real.

s.waitForBoot{

	// Referencia 2. Banco de muestras estable que se compara con las muestras que se graban en el momento

	a = Array.fill(6, {arg i; Buffer.read(s, "~/altamisa/audios/altamisaCello/smpls/va"++(i+4)++".aif")});
	c =  Buffer.read(s, "~/altamisa/audios/altamisaCello/GeomFinal.wav");
	d =  Buffer.read(s, "~/altamisa/audios/altamisaCello/TASCAM_0287.wav");
	e =  Buffer.alloc(s, 44100*1, 1);

	// Referencia 3. Sintetizador. Pendiente: Proxy o SynthDef.

	/// Master, punch, espacio y compresión.

	~outS = {DelayC.ar(~out.ar*1, 0.01, 0.0001*0.5) * EnvFollow.ar(~out.ar, 1 - (0.0001 * SampleRate.ir).reciprocal).max(0.134377).reciprocal * 0.5!2}; // para las otras rolas está a 0.2
	//~outS = {DelayC.ar(~out.ar, 0.01, 0.0001007 * 0.5) * EnvFollow.ar(~out.ar, 1 - (0.0001007 * SampleRate.ir).reciprocal).max(0.08).reciprocal * 0.2!2};
	~outD = {GVerb.ar(BPF.ar(~outS, Array.geom(8, 50, 1.5), 1/4).sum, 80, 5.85, 0.41, 0.19, 15, -3.dbamp, -5.dbamp, -5.dbamp, 80, 1) * 0.05};
		~outD = {GVerb.ar(~outS, 80, 5.85, 0.41, 0.19, 15, -3.dbamp, -5.dbamp, -5.dbamp, 80, 1) * 0.05}
	~outM = ~outS + ~outD;
	~outFinal = {Compander.ar(~outM, ~outM, 0.5, 1.0, 0.5, 0.01, 0.01)};
	~outFinal.play;

	// Referencia 4. Contador.

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

	// Referencia 5. Grabadoras

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

	// Referencia 6. Rutinas que almacenan muestras de audio.

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

	//_____________________________________________________________ OSC __________________________________________________________________

	~manda = NetAddr("127.0.0.1", 57120);

	/// PRIMERA

	~oscuno = OSCFunc({|msg|
		if (msg[1] == 1, {
			/// Si es uno, entonces
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot4', 0);
			~manda.sendMsg('\bot5', 0);
			~rutauno.play;
			~p1.next; ~pAn1.next;
	})}, '/bot1', recvPort: 57120);

	/// SEGUNDA

	~oscdos = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf1 = Buffer.read(s, "/home/huachi/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoAltamisa.wav");
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
			~buf2 = Buffer.read(s, "/home/huachi/Dropbox/altamisa/audios/altamisaCello/recop1/yotraigoMejorana.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot4', 0);
			~manda.sendMsg('\bot5', 0);
			~rutatres.play;
			~p3.next; ~pAn3.next})}, '/bot3', recvPort: 57120);

	/// CUARTA

	~osccuatro = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf3 = Buffer.read(s, "/home/huachi/Dropbox/altamisa/audios/altamisaCello/recop1/traigoAmansaguapo.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot5', 0);
			~rutacuatro.play;
			~p4.next; ~pAn4.next})}, '/bot4', recvPort: 57120);

	/// QUINTA

	~osccinco = OSCFunc({|msg|
		if (msg[1] == 1, {
			~buf4 = Buffer.read(s, "/home/huachi/Dropbox/altamisa/audios/altamisaCello/recop1/yrompesaraguey.wav");
			~manda.sendMsg('\bot1', 0);
			~manda.sendMsg('\bot2', 0);
			~manda.sendMsg('\bot3', 0);
			~manda.sendMsg('\bot4', 0);
			~rutacinco.play;
			~p5.next; ~pAn5.next})}, '/bot5', recvPort: 57120);

}
