;
; task 4.asm
;
; Created: 10/1/2021 2:27:28 PM
; Author : vish7
;

; Replace with your application code
start:
//Configure I/O ports
ldi r16, 0xFF			//load r16 with all 1s
out VPORTD_DIR, r16		//VPORTD output
ldi r16, 0X02			//load r16 with $02
out VPORTE_DIR, r16		//PE1 as /CLR input
ldi r16, 0X00			//loading r16 with all 0s
out VPORTE_OUT, r16		//clear

main:
ldi r18, 0X00			//reset counter

wait_for_1:
sbis VPORTE_IN, 0		//wait for PE0 being 1
rjmp wait_for_1
inc r18
output:
mov r19, r18			//moving r18 into r19
com r19
out VPORTD_OUT, r19		//output the value into bargraph
wait_for_0:
sbic VPORTE_IN, 0		//wait for PE0 being 0
rjmp wait_for_0
rcall var_delay
						
						//make debounce time
delay:
ldi r18, 189

clear_flip_flop:
ldi r20, 0X02			//set PE1=1
out VPORTE_OUT, r20
ldi r20, 0X00			
out VPORTE_OUT, r20


//subroutine
var_delay:				//delay for db48 @ 4 mhz = r16 * 0.1ms
outer_loop:
ldi r17, 133
inner_loop:
dec r17
brne inner_loop
dec r18
brne outer_loop
ret