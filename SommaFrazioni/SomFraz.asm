TITLE Titolo della finestra
; Programma che legge due variabili carattere e le scambia, stampando il risultato

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA                   ; inizio del segmento dati
    num1 db ?
    num2 db ?
    
    den1 db ?
    den2 db ?
    
    numt db ?
    dent db ?
    
    inp1 db 13,10,"INSERIRE IN NOMINATORE DELLA PRIMA FRAZIONE (1 CIFRA): $" 
    inp2 db 13,10,"INSERIRE IN DENOMINATORE DELLA PRIMA FRAZIONE (1 CIFRA): $" 
    inp3 db 13,10,13,10,"INSERIRE IN NOMINATORE DELLA SECONDA FRAZIONE (1 CIFRA): $" 
    inp4 db 13,10,"INSERIRE IN DENOMINATORE DELLA SECONDA FRAZIONE (1 CIFRA): $"

    capo db 13,10,13,10,"$"    
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
        
        mov ah,09h
        mov dx, offset inp1     ; Stampo la prima richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nella variabile nom1
        mov num1,al

        mov ah,09h
        mov dx, offset inp2     ; Stampo la seconda richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nella variabile den1
        mov den1,al
        
        mov ah,09h
        mov dx, offset inp3     ; Stampo la terza richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nella variabile nom2
        mov num2,al
        
        mov ah,09h
        mov dx, offset inp4     ; Stampo la quarta richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nella variabile den2
        mov den2,al

        mov al, den1
        mul den2
        
        mov dent,al               ; memorizzo den1*den2 nella variabile dent

        div den1
        mul num1
        
        mov cl, al

        mov al,dent

        div den2
        mul num2
   
        add ax,cx
        mov numt,al
        mov bl,dent     
        
condi:  cmp ax,bx               ; Comparo ax e bx
        je finec                ; Se sono uguali mi reco alla fine del ciclo
        jg amag                 ; se ax ? maggiore di bx si sbosta al blocco di istruzioni 'amag"
        
        sub bx,ax               ; se bx ? maggiore di ax eseguo bx = bx-ax  
        
        jmp condi               ; finita la procedura ritorna all'inizio del ciclo
        
amag:   sub ax,bx               ; Essendo ax maggiore di bx eseguo ax = ax-bx
        
        jmp condi               ; Finita la procedura ritorna all'inizio del ciclo
        
finec:  mov al,numt
        div bl
        mov numt,al
       
        mov al,dent
        div bl
        mov dent,al
       
        mov ah,09h
        
        mov dx, offset capo     ; Stampo la terza richiesta di input
        int 21h
        
        mov ah,02h
        
        mov dx, offset numt
        add dx,30h
        
        mov ah,09h
        
        mov dx, offset capo     ; Stampo la terza richiesta di input
        int 21h
        
        mov ah,02h
        
        mov dx, offset dent
        add dx,30h
        
        mov ah,09h
        
        mov dx, offset capo     ; Stampo la terza richiesta di input
        int 21h
        
        mov ah,02h
        
        mov dx, bx
        add dx,30h
        
        mov ah,09h
        
        mov dx, offset capo     ; Stampo la terza richiesta di input
        int 21h
        
        
        mov ah,02h  
        
        mov dl,num1
        add dl,30h        
        int 21h 
        
        mov dl,'/'        
        int 21h  
        
        mov dl,den1
        add dl,30h        
        int 21h
        
        mov dl,' '        
        int 21h 
        
        mov dl,'+'        
        int 21h 
        
        mov dl,' '        
        int 21h 
        
        mov dl,num2
        add dl,30h        
        int 21h
        
        mov dl,'/'        
        int 21h 
        
        mov dl,den2
        add dl,30h        
        int 21h
        
        mov dl,' '        
        int 21h 
        
        mov dl,'='        
        int 21h 
        
        mov dl,' '        
        int 21h 
        
        mov bx,0
        mov cl,10
        
        cmp numt,9
        jg divnum
        jmp avanti1
divnum: mov al,numt
        div cl
        mov bh,al
        mov bl,ah
        
        add bh,30h
        add bl,30h
        
        mov ah,02h
        
        mov dl, bh
        int 21h
        
        mov dl, bl
        int 21h
        
        mov dl, '/'
        int 21h
        
        jmp fincmp
avanti1:mov ah,02h

        mov dl, numt
        add dl,30h
        int 21h
        
        mov dl, '/'
        int 21h

fincmp: cmp dent,9
        jg divden
        jmp avanti2
divden: mov al,dent
        div cl
        mov bh,al
        mov bl,ah
        
        add bh,30h
        add bl,30h
        
        mov ah,02h
        
        mov dl, bh
        int 21h
        
        mov dl, bl
        int 21h

        jmp fineprg
avanti2:mov ah,02h
        
        mov dl, dent
        add dl,30h
        int 21h        

fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 