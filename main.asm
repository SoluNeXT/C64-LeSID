#importonce

BasicUpstart2(main)

#import "macros/m_vic.asm"
#import "lib/l_sound.asm"
#import "macros/m_sound.asm"

*=* "MAIN"
main:

	jsr SOUND.RESET

	lda #15
	jsr SOUND.SET_VOLUME

	lda #SOUND.WAVEFORM_SAW
	ldx #0 * 16 + 9
	ldy #0 * 16 + 0 
	jsr SOUND.SET_VOICE1
	jsr SOUND.SET_VOICE2
	jsr SOUND.SET_VOICE3

loop:
	:PlayNote(1,"DO",3)
	:PlayNote(2,"DO",2)
	:PlayNote(3,"DO",2)
	:WaitNbFrames(12)
	:PlayNote(3,"DO",3)
	:WaitNbFrames(12)
	:PlayNote(2,"SOL",1)
	:PlayNote(3,"MI",3)
	:WaitNbFrames(12)
	:PlayNote(3,"SOL",3)
	:WaitNbFrames(12)

	:PlayNote(1,"LA",2)
	:PlayNote(2,"DO",2)
	:PlayNote(3,"LA",2)
	:WaitNbFrames(12)
	:PlayNote(3,"LA",3)
	:WaitNbFrames(12)
	:PlayNote(2,"MI",2)
	:PlayNote(3,"DO",4)
	:WaitNbFrames(12)
	:PlayNote(3,"MI",4)
	:WaitNbFrames(12)

	:PlayNote(1,"FA",2)
	:PlayNote(2,"RE",2)
	:PlayNote(3,"FA",2)
	:WaitNbFrames(12)
	:PlayNote(3,"FA",3)
	:WaitNbFrames(12)
	:PlayNote(2,"LA",1)
	:PlayNote(3,"LA",3)
	:WaitNbFrames(12)
	:PlayNote(3,"DO",4)
	:WaitNbFrames(12)

	:PlayNote(1,"SOL",2)
	:PlayNote(2,"SI",1)
	:PlayNote(3,"SOL",2)
	:WaitNbFrames(12)
	:PlayNote(3,"SOL",3)
	:WaitNbFrames(12)
	:PlayNote(2,"RE",2)
	:PlayNote(3,"SI",3)
	:WaitNbFrames(12)
	:PlayNote(3,"RE",4)
	:WaitNbFrames(12)

	jmp loop

	rts



*=* "END"