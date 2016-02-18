;----------10 modules to guide you in coding with assembler----------
;See: https://www.youtube.com/playlist?list=PLK3PeNcUzb8TYBUxpC2Y9xaXN0wBSY2e0
;---1. Cataloguing ---
;
; * Project name: Screaming Horns and Lighting LEDs!!!
;    Buzzer_N_Leds_01.asm
; *  Copyright: Wagner Rambo (c) and Luiz Bertini (c)
; * Revision History:
;     20160217:
;       - initial release;
; * Description:
;     This code demonstrates how to use buttons to trigger horns/siren.
;     By the time the Button1 is pressed, the LED1 lights and generates 
;     high frequency for the siren, while when the Button2 is pressed, 
;     turns on the LED2 and generates low frequency for the siren.
; * Test configuration:
;     MCU:            PIC16F628A
;                     http://www.microchip.com/wwwproducts/en/en010210
;     Rec.Board:      PicKit3
;                     PicKit3 - http://www.microchip.com/pagehandler/...
;     Oscillator:     16.0000 MHz Crystal
;     Proteus test:   Buzzer_N_Led_03.pdsprj
;                     http://www.
;     SW:             MPLAB X IDE v3.20
;                     http://www.microchip.com/mplab/mplab-x-ide
; * NOTES: based too in MICROCONTROLADORES PIC16F628A EM ASSEMBLY 
;          book by Luiz Bertini 
;          http://www.luizbertini.net/microcontroladores/microcontroladores.html    
; * Date : feb 2016 
;*/

 
;---2. Mcu;--- 
    list		p=16F628			; microcontroller used     
 
;---3. Files included in the Project ---
    #include <P16F628.INC>				; It includes PIC16F84A file
    
;---4. Configuration bits ---
    __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

;---5. Paging Memory --- 
    #define		bank0		bcf STATUS,RP0  ;Create a mnemonic for the bank 0 of memory
    #define		bank1		bsf STATUS,RP0	;Create a mnemonic for the bank 1 of memory

;---6. Variables --- 
    cblock				H'20'
    time0
    time1
    time2
    time3
    endc
    
;---7. Inputs --- 
    #define		button1		PORTB,RB0	;Button1 connected to RB0
    #define		button2		PORTB,RB2	;Button2 connected to RB2
   
;---8. Outputs --- 
    #define		led1		PORTB,RB1	;LED1 connected to RB1
    #define		led2		PORTB,RB3	;LED2 connected to RB3
    #define		buzz		PORTB,RB5	;Buzz connected to RB4

;---9. Interrupt Routines ---
    org			H'0000'				;Origin in the address 0000h memory
    goto		start				;Deviate from the interrupt vector				

;---10. Business Rules Code ---
start:
			bank1				;Selects bank 1 memory
			movlw		H'FF'		;W = B'11111111'
			movwf		TRISA		;TRISA = H'FF' (all bits are input)
			movlw		H'D5'		;W = B'11010101'				
			movwf		TRISB		;TRISB = H'D5'  RB1,RB3 and RB5 as output
			bank0				;selects the bank 0 of memory (RESET of default)
			movlw		H'07'		
                        movwf		CMCON		;Disable the comparators
			movlw		H'D5'		;W = B'11010101'		        
			movwf		PORTB		;LEDs start off
				
scan:							;Infinite Loop scans butts
			clrf		PORTB		;Clean portb
			btfsc		button1		;Test if but1 is zero...
			goto		$+2		;No, then skip 2 lines 
			goto		shake_plenty	;Yes; call Routine 2
			btfsc		button2		;Test if but2 is zero...
			goto		scan		;No, then scan butts again 
			goto		shake_wispy	;Yes; call Routine 1			
			

;---11. Auxiliary Routines ---
 
delay500ms:
			movlw		D'200'		;Move the value for W
			movwf		time0		;Initializes the variable time

							; 4 machine cycles

aux1:
			movlw		D'250'		;Move the value for W
			movwf		time1		;Initializes the variable time 1
	
							;2 machine cycles

aux2:
			nop				;Spending 1 machine cycle
			nop
			nop
			nop
			nop
			nop
			nop

			decfsz		time1		;Time1 decreases until it is zero
			goto		aux2		;Go to the label aux2 
							;250 x 10 = 2500 cycles of machine cycles

			decfsz		time0		;Time0 decreases until it is zero
			goto		aux1		;Go to the label aux1
							;3 machine cycles

							;2500 x 200 = 500000

			return				;Returns after calling subroutine
			
delay1050ms:
			movlw		D'300'		;Move the value for W
			movwf		time2		;Initializes the variable time

							; 4 machine cycles

aux3:
			movlw		D'350'		;Move the value for W
			movwf		time3		;Initializes the variable time 1
	
							;2 machine cycles

aux4:
			nop				;Spending 1 machine cycle
			nop
			nop
			nop
			nop
			nop
			nop

			decfsz		time3		;Time1 decreases until it is zero
			goto		aux4		;Go to the label aux2 
							;350 x 10 = 3500 cycles of machine cycles

			decfsz		time2		;Time0 decreases until it is zero
			goto		aux3		;Go to the label aux1
							;3 machine cycles
							;3500 x 300 = 1.050.000
			return				;Returns after calling subroutine
			
shake_wispy:						;Routine responsible for making 
							;shake more slowly siren    
			;bsf		led1		;LED1 lights				
			bcf		led2		;Off LED 2
			bcf		buzz		;Buzz Off
			call		delay500ms	;Subroutine call
			;bcf		led1		;Off LED1				
			bsf		led2		;LED2 lights
			bsf		buzz		;Buzz On
			call		delay500ms	;Subroutine call
			btfsc		button1		;Butt1 is still pressed?
			goto		scan		;No,Back to scan buttons
			goto		shake_wispy	;Yes,loop this routine
			return				;After calling, return
    
shake_plenty:						;Routine responsible for making 
							;shake the siren faster
		        bsf		led1		;LED1 lights				
			;bcf		led2		;Off LED 2
			bsf		buzz		;Buzz on
			call		delay1050ms	;Subroutine call
			bcf		led1		;Off LED1				
			;bsf		led2		;LED2 lights
			bcf		buzz		;Buzz Off
			call		delay1050ms	;Subroutine call
			btfsc		button2		;Butt2 is still pressed?
			goto		scan		;No,Back to scan buttons
			goto		shake_plenty	;Yes,loop this routine
			return				;After calling, return		
			end				;Program end









