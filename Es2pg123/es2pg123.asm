TITLE Titolo della finestra
; Programma attribuisce ad AX un valore e ne scambia le parti

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA                   ; inizio del segmento dati
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
      MOV AX,120
      
     MOV BL,AL
     MOV AL,AH
     MOV AH,BL

fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 