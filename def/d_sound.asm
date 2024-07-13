#importonce

#import "../main.asm"

* = * "D_SOUND"

.namespace SOUND{
	.label VOICE1 = $d400
	.label VOICE2 = $d407
	.label VOICE3 = $d40E

	.label FREQUENCELO		= 0
	.label FREQUENCEHI		= 1
	.label PULSEWIDTHLO		= 2
	.label PULSEWIDTHHI		= 3
	.label CONTROLREG		= 4
	.label ATTACKDECAY		= 5
	.label SUSTAINRELEASE	= 6

	.label FILTERCUTOFFFREQUENCYLO	= $D415
	.label FILTERCUTOFFFREQUENCYHI	= $D416
	.label FILTERCONTROL			= $D417
	.label VOLUMEANDFILTERMODES		= $D418

	.label WAVEFORM_TRIANGLE		= %00010000
	.label WAVEFORM_SAW				= %00100000
	.label WAVEFORM_RECTANGLE		= %01000000
	.label WAVEFORM_NOISE			= %10000000

	.label CTRL_DISABLEVOICE		= %00000001


	.zp{
		.label MEM_WAVEFORM_VOICE1	= $F1
		.label MEM_WAVEFORM_VOICE2	= $F2
		.label MEM_WAVEFORM_VOICE3	= $F3
	}

	.label LA4 = 440 // Hz
	.label SFC = 16777216 / 985248

}