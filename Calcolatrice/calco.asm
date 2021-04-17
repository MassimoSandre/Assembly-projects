TITLE sch
; Programma che legge due variabili carattere e le scambia, stampando il risultato

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA                   ; inizio del segmento dati
    _NUMINT dw 0h       ; numero da leggere/stampare
    _DIECI dw 0ah
    
    _DECIMALI dw 5h
    _TIMES dw 0h
    
    _RIS dw 0h
    _RESTO dw 0h
    
    _RISMUL dw 0h
    
    _OPE1 dw 0h
    _OPE2 dw 0h
    
    
    
    _SEGNO dw 0h
; Titolo del programma
    stringa1 db "CALCOLATRICE",10,13,10,13,"$"

    inp1 db "INSERIRE IL PRIMO NUMERO: $"
    inp2 db 10,13,10,13,"INSERIRE IL SECONDO NUMERO: $"
    inp3 db 10,13,10,13,"INSERIRE L'OPERAZIONE DA ESEGUIRE: $"
    err1 db 10,13,10,13,"OPERAZIONE NON RICONOSCIUTA REINSERIRE$"
    err2 db 10,13,10,13,"IMPOSSIBILE EFFETTUARE DIVISIONI PER 0$"
    
    bln db 10,13,10,13,"$"
    spc db " $"
    
    res db " RESTO: $"
        
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
        mov ah,09h      ; stampa titolo programma
        mov dx,offset stringa1
        int 21h
        
        mov ah,09h      ; stampa titolo programma
        mov dx,offset inp1
        int 21h
        
        call LETNUM
        mov ax,_NUMINT
        mov _OPE1,ax

        mov ah,09h        
        mov dx,offset inp2
        int 21h
        
        call LETNUM
        mov ax,_NUMINT
        mov _OPE2,ax

segn:   mov ah,09h
        mov dx,offset inp3
        int 21h    
        
        mov ah,01h
        int 21h
        mov ah,0
       
        mov _SEGNO,ax
        
        cmp _SEGNO,43
        je addi
        cmp _SEGNO,45
        je sott
        cmp _SEGNO,47
        je divi
        cmp _SEGNO,42
        je molt
        
        mov ah,09h
        mov dx,offset err1
        int 21h  
        
        jmp segn
        addi:   mov dx,_OPE1
        add dx,_OPE2
        mov _RIS,dx
        jmp fineope
sott:   mov dx,_OPE1
        sub dx,_OPE2
        mov _RIS,dx
        jmp fineope    
divi:   cmp _OPE2,0
        jne pro
        mov ah,09h
        mov dx,offset err2
        int 21h  
        jmp fineprg        
pro:
        mov dx,0
        mov ax,_OPE1
        idiv _OPE2
        mov _RIS,ax
        mov _RESTO,dx
        jmp finediv
molt:   mov ax,_OPE1
        imul _OPE2
        mov _RIS,AX
        mov _RISMUL,dx
fineope:
        mov ah,09h
        mov dx,offset bln
        int 21h    
        
        mov ax,_OPE1
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ah,02h
        mov dx,_SEGNO
        int 21h   
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ax,_OPE2
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ah,02h
        mov dl, 61
        int 21h
      
        mov ah,09h
        mov dx,offset spc
        int 21h 
        
        mov ax,_RIS
        mov _NUMINT,ax
        call STNUM
        
        JMP fineprg
                    
        

        
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
LETNUM ENDP             ; FINE PROCEDURA LETNUM - LETTURA NUMERO INTERO WORD


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

finediv: 
        mov ah,09h
        mov dx,offset bln
        int 21h    
        
        mov ax,_OPE1
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ah,02h
        mov dx,_SEGNO
        int 21h   
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ax,_OPE2
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ah,02h
        mov dl, 61
        int 21h
      
        mov ah,09h
        mov dx,offset spc
        int 21h 
        
;decim:  inc _TIMES
 ;       cmp _TIMES, 5
 ;      jng decim
        
        mov ax,_RIS
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset res
        int 21h 
        
        mov ax,_RESTO
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset bln
        int 21h
        
        jmp fineprg

finemul:
        mov ah,09h
        mov dx,offset bln
        int 21h    
        
        mov ax,_OPE1
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ah,02h
        mov dx,_SEGNO
        int 21h   
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ax,_OPE2
        mov _NUMINT,ax
        call STNUM
        
        mov ah,09h
        mov dx,offset spc
        int 21h  
        
        mov ah,02h
        mov dl, 61
        int 21h
      
        mov ah,09h
        mov dx,offset spc
        int 21h     
        cmp _RISMUL,0
        je sml        
        mov ax,_RISMUL
        mov _NUMINT,ax
        call STNUM 
sml:
        mov ax,_RISMUL
        mov _NUMINT,ax
        call STNUM 
        jmp fineprg

fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 