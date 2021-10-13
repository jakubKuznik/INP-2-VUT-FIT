; Vernamova sifra na architekture DLX
; Jakub Kuzník xkuzni04

        .data 0x04          	; zacatek data segmentu v pameti
login:  .asciiz "xkuzni04"  	; <-- nahradte vasim loginem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; k = 11
; u = 21 

cipher: ;.space 9 		;sem ukladejte sifrovane znaky 
				;(za posledni nezapomente dat 0)
        .align 2            	; dale zarovnavej na ctverice (2^2) bajtu



laddr:  .word login         	; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        	; 4B adresa sifrovaneho retezce (pro vypis)


        .text 0x40          	; adresa zacatku programu v pameti
        .global main        	; 




;xkuzni04 -r15-r16-r19-r20-r23-r0


; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
main:   
	addi r16, r0, 11 	; index v abecede meho pismena k 
	addi r19, r0, 21	; index v abecede meho pismena u
	addi r15, r0, 64        ; asci value where alpha characters start
		
	;sgt  r3,r1,r2     ; if r1>r2 then r3=1 else r3 = 0
        ;bnez r3, true     ; branch if r3 not equals zero


;---------------------------------------------------------------------
 ;loop:
	lb r23, login+0(r20)	; načte bajt z adresy login index 0	
				;if number 
	addi r16, r0, 0
	addi r19, r23, 0

	sgt r19, r15, r16       ; porovna aktualni znak a zjisti jestli je pismeno nebo cislo
	bnez r16, num		; pokud to je cislo skoci na navesti cislo
	
	addi r19, r0, 21	; vrati puvodni hodnotu 
	addi r16, r0, 11        ; vrati puvodni hodnotu 	
	
	;nop	
	;nop	

	;todo shift over edges
	add r19, r0, r23
	add r19, r19, r16

	sb cipher(r20), r19     ; uloží bajt do cipher na index 0
	addi r19, r0, 21

	addi r23, r23, 1   	; pointer increment
	addi r20, r20, 1   	; pointer increment
	
	;j loop	
;---------------------------------------------------------------------
	

   num:
	


end: 	addi r14, r0, caddr 	; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5   		; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  		; ukonceni simulace



;Za návěštím cipher je vyhrazeno neinicializované místo pro
;zašifrovaný text. Sem zapisujte zašifrované znaky. Za návěštím end
;je připraven kód pro výpis uvítacího textu pomocí systémového
;volání (trap), který změnte na výpis zašifrovaného textu. Pro
;správnou funkci výpisu musí být řetězec ukončen hodnotou 0. Řiďte
;se komentáři v textu a vaše řešení též přiměřeně komentujte.

;Za návěští main zapište vaše řešení. Po dokončení soubor
;vernam.s přejmenujte na váš login (se zachováním přípony .s)
;a odevzdejte do IS FIT (bez zipování nebo jiných příloh).	