//ON THE ORIGIN OF THE WORLDS
//Composed and programmed by David Gerard Matthews, 2019
//The code below is licensed under the terms of the GNU GPL, v.3
//Resulting music is released under the terms of the Creative Commons Share-alike license
//Contact: matyas 4 7 AT gmail DOT com

Server.default.waitForBoot

//s.boot;
({
{
	var base_frequency = 29.135,
	orbital_period = 1/base_frequency,
	bassus_profundus = (base_frequency + (SinOsc.kr((1/base_frequency), mul: 1.364))),
	bassus = ((base_frequency * (9/2)) + (SinOsc.kr(0.000361, mul: 90.138))),
	tenor = ((base_frequency * (81/8)) + (SinOsc.kr((1/bassus) * (81/8), mul: 18.438))),
	superius = ((base_frequency * 22) + (SinOsc.kr((1/tenor) * (49/40), mul: 174.81))),
	discantus = ((base_frequency * 47) + (SinOsc.kr((1/superius) * (47/29.135), mul: 264.25))),

	bassus_profundus_EG = (LFPar.kr(freq:(orbital_period/47), iphase: Rand(0.11, 0.47), mul: 0.25, add: 0.47) * 0.7),

	bassus_EG = (LFPar.kr(freq:(orbital_period * (1/47)), iphase: Rand(0.11, 0.47), mul: 0.17, add: 0.9) * 0.047),

	tenor_EG_freq = ((orbital_period) * LFTri.kr(0.5, iphase:(Rand(0.47, 1.0)), mul: 0.5, add: 0.5)),
	tenor_attack = (tenor_EG_freq * LFTri.kr(0.1, mul: 0.115, add: 0.117)),
	tenor_release = (tenor_EG_freq - (tenor_attack *
		(LFTri.kr(0.01, iphase: (Rand(0.0, 1.0)),  mul: 0.115, add: 0.117) * 0.45))),
	tenor_sustain = tenor_attack - tenor_release,
	tenor_env = Env([0.0, 0.3, 0.2, 0.0], [tenor_attack, tenor_release]),
	tenor_EG = (EnvGen.kr(tenor_env,
		gate: (Impulse.kr(tenor_EG_freq)))),

	superius_EG_freq = ((orbital_period * 5) * LFTri.kr(1.1, iphase:(Rand(0.59, 1.0)), mul: 0.5, add: 0.5)),
	superius_attack = (superius_EG_freq * LFTri.kr(0.1, mul: 0.115, add: 0.117)),
	superius_release = (superius_EG_freq - (superius_attack *
		(LFTri.kr(0.01, iphase: (Rand(0.0, 1.0)),  mul: 0.115, add: 0.117) * 0.45))),
	superius_sustain = superius_attack - superius_release,
	superius_env = Env([0.0, 0.3, 0.2, 0.0], [superius_attack, superius_release]),
	superius_EG = (EnvGen.kr(superius_env,
		gate: (Impulse.kr(superius_EG_freq)))),

	discantus_EG_freq = ((orbital_period * 11) * LFTri.kr(1.23, iphase:0.95, mul: 0.5, add: 0.5)),
	discantus_attack = (discantus_EG_freq * LFTri.kr(0.1, mul: 0.115, add: 0.117)),
	discantus_release = (discantus_EG_freq - (discantus_attack *
		(LFTri.kr(0.01, iphase: (Rand(0.0, 1.0)),  mul: 0.115, add: 0.117) * 0.45))),
	discantus_sustain = discantus_attack - discantus_release,
	discantus_env = Env([0.0, 0.3, 0.2, 0.0], [discantus_attack, discantus_release]),
	discantus_EG = (EnvGen.kr(discantus_env,
		gate: (Impulse.kr(discantus_EG_freq)))),

	planets = ((MoogFF.ar(in:
			LFTri.ar
			(freq: [bassus_profundus, bassus, tenor, superius, discantus],
			mul: [bassus_profundus_EG, bassus_EG, (tenor_EG * 0.5), (superius_EG * 0.5), (discantus_EG * 0.5)]),
		//filter frequencies
		freq: [(SinOsc.kr(orbital_period, mul: 940, phase: Rand(0.1, 0.95), add: 1060)),
			(SinOsc.kr((orbital_period / 2), phase: Rand(0.1, 0.95), mul: 800, add: 1000)),
			(SinOsc.kr((orbital_period / 5), phase: Rand(0.1, 0.95), mul: 1800, add: 2200)),
			(SinOsc.kr((orbital_period / 11), phase: Rand(0.1, 0.95), mul: 2000, add: 2300)),
			(SinOsc.kr((orbital_period / 23), phase: Rand(0.1, 0.95), mul: 3700, add: 4300))
		]))
	),

	universe = Pan2.ar(
	in: planets,
		pos: [0.0,
			(SinOsc.kr(freq: (orbital_period/11), phase: Rand(0.1, 0.95))),
			(SinOsc.kr(freq: (orbital_period/23), phase: Rand(0.1, 0.95))),
			(SinOsc.kr(freq: (orbital_period/47), phase: Rand(0.1, 0.95))),
			(SinOsc.kr(freq: (orbital_period/95), phase: Rand(0.1, 0.95)))]
	).sum;


	GVerb.ar(in: (universe * 0.023), roomsize: 190, revtime: 1.23, damping: 0.62,
		inputbw: 0.48, drylevel: 0, earlyreflevel: -11, taillevel: -13);

}.play;})