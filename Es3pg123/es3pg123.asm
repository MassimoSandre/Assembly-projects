TITLE Titolo della finestra
; Programma attribuisce ad AX, BX, CX, DX un valore e sposta in variabili

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA 
    VAR1    DW  ?
    VAR2    DW  ?
    VAR3    DW  ?
    VAR4    DW  ?
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
    MOV AX, 29          ; attribuisco a AX un valore
    MOV BX, 2h          ; attribuisco a BX un valore
    MOV CX, 99          ; attribuisco a CX un valore
    MOV DX, 102         ; attribuisco a DX un valore
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    POP VAR4        ; copio il valore nel registro AX nella variabile 1
    POP VAR3        ; copio il valore nel registro BX nella variabile 2
    POP VAR2        ; copio il valore nel registro CX nella variabile 3
    POP VAR1        ; copio il valore nel registro DX nella variabile 4
    
fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 