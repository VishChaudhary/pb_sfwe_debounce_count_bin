;
; .asm
;
; Created: 09/30/2021 7:01:22 PM
; Author : vish7
; Target: AVR128DB48

; Replace with your application code
start:
;Configure I/O ports
	ldi r16, 0xFF 	;load r16 with all 1s
	out VPORTD_DIR, r16 	;VPORTD output
	out VPORTD_OUT, r16 	;VPORTD all output 1s
	cbi VPORTE_DIR, 0
	ldi r16, 0xFF 	;load r16 with all 1s

wait_for_1:
	sbis VPORTE_IN, 0 	;wait for PE0 being 1
	rjmp wait_for_1
wait_for_0:
	sbic VPORTE_IN, 0 	;wait for PE0 being 0
	rjmp wait_for_0		

				;make debounce time

delay:
	ldi r18, 36
	rcall var_delay
wait_for_0_again:
	sbic VPORTE_IN, 0 	;wait for PE0 being 0
	rjmp wait_for_1 	;if not go back to waiting for 1

				;good key press

increment:
	sbic VPORTE_IN, 0 	;wait for PE0 being 0
	rjmp wait_for_0
	dec r16 		;increment the counter
	out VPORTD_OUT, r16 	;output counter

				;after registering a good keypress

wait_for_1_again:
	sbis VPORTE_IN, 0
	rjmp wait_for_1_again

				;break debounce time

delay2:
	ldi r18, 36
	rcall var_delay
check_for_1:
	sbis VPORTE_IN, 0
	rjmp wait_for_1_again 	;go back to wait_for_1_again if input 1

check_for_FF:
	cpi r16, 0xFF 		;comparing counter to $FF
	breq FF_clear
	rjmp wait_for_1

				;clearing counter if maxed out

FF_clear:
	andi r16, 0x00
	rjmp wait_for_1

			;subroutine
var_delay: 		;delay for db48 @ 4 mhz = r16 * 0.1ms
outer_loop:
	ldi r17, 133
inner_loop:
	dec r17
	brne inner_loop
	dec r18
	brne outer_loop
	ret
