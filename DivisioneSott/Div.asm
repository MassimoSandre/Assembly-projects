TITLE mult

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA                   ; inizio del segmento dati
    
; Titolo del programma

    _NUMINT dw 0h       ; numero da leggere/stampare
    _DIECI dw 0ah    
    
    _DIV dw 0h

    _VOLTE dw 0h
 
    
    inp1 db "INSERIRE IL DIVIDENDO: $"
    inp2 db "INSERIRE IL DIVISORE: $"
    
    str1 db 13,10,"IL RISULTATO DELLA DIVISIONE E' $"
    str2 db " CON IL RESTO DI $"
       
.CODE                   ; inizio del segmento di codice
.STARTUP
        mov ah, 09h
        mov dx, offset inp1
        int 21h 
        
        call LETNUM
        mov cx,_NUMINT
        mov _DIV,cx
        
        mov ah, 09h
        mov dx, offset inp2
        int 21h
        
        call LETNUM
        mov ax,_NUMINT
        
ciclo:
        cmp _DIV,ax        
        jl output 
        add _VOLTE,1
        sub _DIV,ax
        jmp ciclo      
  
output: 
        mov ah,09h      
        mov dx,offset str1
        int 21h
        
        mov cx,_VOLTE
        mov _NUMINT,cx

        
        call STNUM

        mov ah,09h      
        mov dx,offset str2
        int 21h
        
        mov cx,_DIV
        mov _NUMINT,cx
        call STNUM
        
        jmp fineprg    
        
LETNUM PROC             ; PROCEDURA DI LETTURA NUMERO INTERO WORD
                        ; IL NUMERO LETTO VIENE MESSO NELLA VARIABILE _NUMINT
                        ; Utilizza variabile _DIECI = 10
        mov bx,0        ; azzero registro che contiene il numero letto
_cick1: mov ah,01h      ; lettura di un carattere
        int 21h
        cmp al,0dh      ; Se il carattere letto e' INVIO allora fine ciclo
        je _endk1
        push ax         ; Salvo copia del numero letto
        mov ax,bx       ; Moltiplico il numero accumulato in BX per 10 (sposto cifre a sinistra)
        MUL _DIECI
        mov bx,ax       ; Metto in BX il numero spostato a sinistra di una cifra
        pop ax          ; Riprendo cifra appena letta
        sub al,30h      ; Sottraggo ASCII di 0 (per avere numero reale)
        mov ah,0        ; Sommo nuova cifra al numero letto (totale cifre gia' spostate a sinistra)
        add bx, ax
        jmp _cick1
_endk1: mov _NUMINT,bx  ; Metto in NUMINT il numero letto
        ret
LETNUM ENDP 
        
STNUM PROC              ; PROCEDURA DI STAMPA NUMERO INTERO WORD
                        ; IL NUMERO DA STAMPARE DEVE TROVARSI NELLA VARIABILE _NUMINT
                        ; Utilizza variabile _DIECI = 10
        mov ax,_NUMINT
        mov cl,00       ; contatore cifre
estraz: mov dx,0        ; Ciclo estrazione cifra. Azzera parte alta dividendo (DX:AX)
        div _DIECI      ; Divisione (DX:AX/10) Quoziente in AX resto in DX
        push dx         ; Salvataggio resto (cifra estratta) nello stack
        inc cl          ; aggiorna contatore cifre
        cmp ax,0        ; controlla se ci sono altre cifre oppure 0
        jne estraz      ; Ripeti finche' ci sono cifre significative (diverse da 0)
stamp:  pop dx          ; Inizio ciclo stampa cifre ordine inverso
        add dl,30h      ; Somma ASCII carattere 0
        mov ah,02h      ; Stampa cifra
        int 21h
        dec cl          ; decrementa contatore cifre da stampare
        jnz stamp       ; Ripeti finche' ci sono cifre salvate da stampare
        ret
STNUM ENDP
        
        
fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 