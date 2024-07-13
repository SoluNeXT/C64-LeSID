#importonce

#import "../main.asm"
#import "../lib/l_sound.asm"

* = * "M_SOUND"


.function GetNoteFrequency(note, octave){
	.var idNote = 0 // LA-4
	.if(note == "LA#"  || note == "SIb" || note == "A#" || note == "Bb")	.eval idNote = 1
	.if(note == "SI"   				    || note == "B" )					.eval idNote = 2
	.if(note == "DO"   				    || note == "C" )					.eval idNote = -9
	.if(note == "DO#"  || note == "REb" || note == "C#" || note == "Db")	.eval idNote = -8
	.if(note == "RE"   				    || note == "D" )					.eval idNote = -7
	.if(note == "RE#"  || note == "MIb" || note == "D#" || note == "Eb")	.eval idNote = -6
	.if(note == "MI"   				    || note == "E" )					.eval idNote = -5
	.if(note == "FA"   				    || note == "F" )					.eval idNote = -4
	.if(note == "FA#"  || note == "SOLb"|| note == "F#" || note == "Gb")	.eval idNote = -3
	.if(note == "SOL"  				    || note == "G" )					.eval idNote = -2
	.if(note == "SOL#" || note == "LAb" || note == "G#" || note == "Ab")	.eval idNote = -1
	.eval idNote = idNote + 12 * (octave - 4)
	.return round(SOUND.LA4 * SOUND.SFC * pow(2,idNote /12))
}

.macro WaitNbFrames(nbFrames){
	ldx #nbFrames 
loop:	
	:WaitRasterLine(260)
	:WaitRasterLine(270)
	dex
	bne loop
}

.macro PlayNote(voice, note, octave){
	inc VIC.BORDER_COLOR
	.var f = GetNoteFrequency(note, octave)
	ldx #<f
	ldy #>f
	.if(voice == 1){
		jsr SOUND.PLAYNOTE_VOICE1
	}
	.if(voice == 2){
		jsr SOUND.PLAYNOTE_VOICE2
	}
	.if(voice == 3){
		jsr SOUND.PLAYNOTE_VOICE3
	}
	dec VIC.BORDER_COLOR

}


	// On va faire un peu de maths !!!
	/*

	PAL
		lines_on_screen = 312		|
		cycles_per_line = 63		| ==> 312 * 63 * 50,12454212 = 985248 cycles_per_second
		framerate = 50,12454212		|



	NTSC (v1 = old)
		lines_on_screen = 262		|
		cycles_per_line = 64		| ==> 262 * 64 * 59,86199905 = 1003766 cycles_per_second
		framerate = 59,86199905 	|



	NTSC (v2 = new)
		lines_on_screen = 263		|
		cycles_per_line = 64 		| ==> 263 * 65 * 59,8260895 = 1022727 cycles_per_second
		framerate = 59,8260895 		|


Le SID a une constante de fréquence : SFC = 256^3 / cycles_per_second

DONC...
	PAL 			: SFC = 16777216 / 985248  = 17,02841924063789

	NTSC old		: SFC = 16777216 / 1003766 = 16,71427005895796

	NTSC new		: SFC = 16777216 / 1022727 = 16,40439335228267

On peut à présent calculer la fréquence à affecter au SID pour chacune de nos notes...

Soit le LA-4 (La octave 4) ou A4 en englais = 440 Hz = NOTE_FREQ

	PAL				: SID_FREQ = SFC * NOTE_FREQ = 17,02841924063789 * 440 = 7493 = $1D45

	NTSC old		: SID_FREQ = SFC * NOTE_FREQ = 16,71427005895796 * 440 = 7354 = $1CBA

	NTSC new		: SID_FREQ = SFC * NOTE_FREQ = 16,40439335228267 * 440 = 7218 = $1C32

Vous savez donc désormais comment calculer vos fréquences en fonction de la machine ciblée...

MAIS, ça c'est pour le LA-4 à 440 Hz...

En fait, la musique ce sont AUSSI des mathématiques.
Pour passer d'une octave à une autre, on multiplie ou on divise la fréquence par 2

Donc entre LA-4 et LA-5 (A-4 => A-5) on passe de 440 Hz à 880 Hz
De même, entre LA-4 et LA-3 (A-4 => A-3) on passe de 440 Hz à 220 Hz

Et comme il existe 12 notes, les calculs seront également faciles à réaliser !

Les notes : DO DO# RE RE# MI FA FA#  SOL SOL# LA  LA# SI
			C  C#  D  D#  E  F  F#   G   G#   A   A#  B
			   REb    MIb       SOLb     LAb      SIb
			   Db     Eb        Gb       Ab       Bb

L'écart de fréquence entre les note est constant
(les puristes diront NON car entre DO et RE, il faudrait diviser en 9 comas... 
et donc DO# et REb n'ont pas purement la même fréquence !)

Bref... Comme l'écart est constant, on a donc la formule suivante entre deux notes:

DO => DO# : FREQUENCE_DO# = FREQUENCE_DO * 2^(1/12)

F => E : FREQUENCE_E = FREQUENCE_F / 2^(1/12) = FREQUENCE_F * 2^(-1/12)

Du coup, pour avoir la fréquence en Hertz du SOL-4 :
LA-4 => SOL-4 : FREQ_SOL4 = FREQ_LA * 2^(-2/12) = 440 * 2^(-2/12) = 392 Hz
Donc pour jouer un G-4 sur un C64 PAL... je dois utiliser la 
			SID_FREQ = 17,02841924063789 * 392 = 6675 = $1A13

Le SID pourra vous jouer les notes du DO-0 (C-0) au LA#-7 (A#-7) sur les C64 PAL et NTSC old
												 au SI-7 (B-7) sur les C64 NTSC new

Nous allons préparer notre code pour un C64 PAL, mais libre à vous de modifier les constantes...												 













	*/

