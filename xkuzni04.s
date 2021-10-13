; Vernamova sifra na architekture DLX
; Jakub Kuzník xkuzni04

        .data 0x04          	; zacatek data segmentu v pameti
login:  .asciiz "xkuzni04"  	; <-- nahradte vasim loginem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cipher: ;.space 9 		;sem ukladejte sifrovane znaky 
				;(za posledni nezapomente dat 0)
        .align 2            	; dale zarovnavej na ctverice (2^2) bajtu

laddr:  .word login         	; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        	; 4B adresa sifrovaneho retezce (pro vypis)


        .text 0x40          	; adresa zacatku programu v pameti
        .global main        	


;xkuzni04 -r15-r16-r19-r20-r23-r0


; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
main:   
	; a = 97 ASCI 
	; z = 122 ASCI
	; k = 11 ASCI	
	; u = 21 ASCI


	addi r19, r0, 21	; index v abecede meho pismena u

;---------------------------------------------------------------------
 loop:

;!!!!!!!!!!!!!!!! LICHY INDEX !!!!!!!!!!!!!!!!!!!!!!!!!

	lb r23, login(r20)	;načte bajt z adresy login index 0	

;########## NUMBER CHECK   	; if number go to :number
	addi r16, r0, 0
	addi r15, r0, 97        ; asci value where alpha characters start 
	sgt r16, r15, r23       ; porovna aktualni znak a zjisti jestli je pismeno nebo cislo
	bnez r16, num		; pokud to je cislo skoci na navesti cislo
;#########################
	nop	
	nop	
	
;########### Check if asci overflow
	add r19, r0, r23   	; store to temp variable becouse dont want to increment pointer
	addi r19, r19, 11  	; increment asci value 
	addi r16, r0, 122   	; 122 is max asci value 
	addi r15, r0, 0	        ; condition register
	sgt r15, r19, r16     	; check if asci value overflow value of z that is 122
	bnez r15, overflow_over
;######################
	nop	
	nop	

;##### ZAPIS HODNOTY A INKREMENT 
	sb cipher(r20), r19     ; uloží bajt do cipher na index 
continue:	
	addi r23, r23, 1   	; pointer increment
	addi r20, r20, 1   	; pointer increment
;#################################

	
;!!!!!!!!!!!!!!!!!!Sudy index !!!!!!!!!!!!!!!!!!

	lb r23, login(r20)	;načte bajt z adresy login index 0	

;########## NUMBER CHECK   	; if number go to :number
	addi r16, r0, 0
	addi r15, r0, 97        ; asci value where alpha characters start 
	sgt r16, r15, r23       ; porovna aktualni znak a zjisti jestli je pismeno nebo cislo
	bnez r16, num		; pokud to je cislo skoci na navesti cislo
;#########################
	nop	
	nop	

;########### Check if asci underflow
	add r19, r0, r23   	; store to temp variable becouse dont want to increment pointer
	subi r19, r19, 21  	; decrement asci value 
	addi r16, r0, 97   	; 97 is smallest asci value 
	addi r15, r0, 0	        ; condition register
	sgt r15, r16, r19    	; check if asci value underflow 97
	bnez r15, overflow_under
;######################
	nop	
	nop	

;##### ZAPIS HODNOTY A INKREMENT 
	sb cipher(r20), r19     ; uloží bajt do cipher na index 
continue_under:	
	addi r23, r23, 1   	; pointer increment
	addi r20, r20, 1   	; pointer increment
;#################################
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	j loop	


overflow_under:
	addi r15, r0, 97
	sub r15, r15, r19
	
	addi r19, r0, 122
	sub r19, r19, r15	
	sb cipher(r20), r19     ; uloží bajt do cipher na index 
	j continue_under


overflow_over:
	addi r15, r0, 122
	sub r19, r19, r15
	addi r15, r0, 97	
	add r19, r19, r15
	sb cipher(r20), r19     ; uloží bajt do cipher na index 
	j continue

num:		
	addi r19, r0, 0x00
	sb cipher(r20), r19     ; uloží bajt do cipher na index 0


end: 	addi r14, r0, caddr 	; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5   		; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  		; ukonceni simulace


