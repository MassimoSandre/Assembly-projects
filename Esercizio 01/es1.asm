TITLE Stampa
; Programma che legge due variabili carattere e le scambia, stampando il risultato

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA                   ; inizio del segmento dati
    
; Titolo del programma
    stringa1 db "Assembly e' un bellissimo linguaggio",13,10,13,10,"$"
    stringa2 db "Massimo Albino Sandretti",13,10,"$"
    stringa3 db "",13,10,13,10,"Carattere inserito: $"

        
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
        mov ah,09h      ; stampa titolo programma
        mov dx,offset stringa1
        int 21h
        
        mov ah,09h      
        mov dx,offset stringa2
        int 21h
        
        mov ah,01h      ; chiedo in input un carattere
        int 21h
        
        mov ah,09h      ; stampo la stringa3
        mov dx,offset stringa3
        int 21h 
        
        mov ah,02h      ; stampo il carattere preso in input
        mov dl,al
        int 21h

fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 