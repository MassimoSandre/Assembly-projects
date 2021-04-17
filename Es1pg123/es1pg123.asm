TITLE Titolo della finestra
; Programma attribuisce ad AX un valore e ne scambia le parti

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA 
    BASE    DW 'a'
    ALTEZZA DW 'b'
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
    MOV AX, BASE        ; copio in AX la variabile BASE
    MOV BX, ALTEZZA     ; copio in BX la variabile ALTEZZA
    
    MOV CX, AX          ; copio AX in CX
    MOV DX, BX          ; copio BX in DX
    
    PUSH CX
    PUSH DX
                        ; scambio CX e DX utilizzando lo stack
    POP CX
    POP DX
    
    MOV AL,CH           ; copio la parte alta di CX (CH) in AL
    MOV AH,CL           ; copio la parte bassa di CX (CL) in AH
    
    MOV BL,DH           ; copio la parte alta di DX (DH) in BL
    MOV BH,DL           ; copio la parte bassa di DX (DL) in BH
    
    
fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 