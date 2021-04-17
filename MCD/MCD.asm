TITLE MCD
; Programma che prende 2 numeri da 2 cifre e ne calcola il massimo comune divisore

.MODEL small            ; indica al compilatore il modello di memoria da usare
.STACK 100h             ; dimensiona lo Stack

.DATA                   ; inizio del segmento dati
    
; Titolo del programma
    msg1 db 13,10,"INSERIRE LA PRIMA CIFRA DEL PRIMO NUMERO: $"
    msg2 db 13,10,"INSERIRE LA SECONDA CIFRA DEL PRIMO NUMERO: $"               ; Dichiaro i messaggi di input
    msg3 db 13,10,13,10,"INSERIRE LA PRIMA CIFRA DEL SECONDO NUMERO: $"
    msg4 db 13,10,"INSERIRE LA SECONDA CIFRA DEL SECONDO NUMERO: $"
    
    str1 db 13,10,13,10,13,10,"L'MCD E': $"                                     ; Dichiaro il messaggio di output
        
    exit db 13,10,13,10,13,10,"Premere un tasto per continuare... $"            ; Dichiaro il messaggio di attesa per la terminazione del programma
    
.CODE                   ; inizio del segmento di codice
.STARTUP                ; inizializza DS e ES
        
        mov ah,09h
        mov dx, offset msg1     ; Stampo la prima richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nel registro bh
        mov bh,al
        
        mov ah,09h
        mov dx, offset msg2     ; Stampo la seconda richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nel registro bl
        mov bl, al
        
        mov ah,09h
        mov dx, offset msg3     ; Stampo la terza richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Nel registro ch
        mov ch,al
        
        mov ah,09h
        mov dx, offset msg4     ; Stampo la quarta richiesta di input
        int 21h
        
        mov ah,01h
        int 21h                 ; Registro la risposta e ne salvo il valore (togliendo 30h dal codice ascii)
        sub al,30h              ; Ner registro cl
        mov cl,al
        
        mov ah,10               ; Predispongo il registro ax alla fusione della prima cifra inserita con la
        mov al,bh               ; seconda in modo da creare un numero a 2 cifre
                                ; Pongo 10 in ah (fattore mul) e la prima cifra inserita (memorizzata in bh) in al (fattore mul)    
        
        mul ah                  ; Eseguo la moltiplicazione: ax = al*ah (prima cifra*10)
        
        add al,bl               ; Aggiungo a al risultato  la seconda cifra (bl) in modo da ottenere un numero composto dalle 2 cifre inserite
        
        mov bx,ax               ; Sposto il primo numero in bx, in modo da liberare ax per la moltiplicazione successiva
        
        mov ah,10               ; Predispongo il registro ax alla fusione della terza cifra inserita con la    
        mov al,ch               ; quarta in modo da creare un numero a 2 cifre
                                ; Pongo 10 in ah (fattore mul) e la terza cifra inserita (memorizzata in ch) in al (fattore mul)
        
        mul ah                  ; Eseguo la moltiplicazione: ax = al*ah (terza cifra*10)
        
        add al,cl               ; Aggiungo a al risultato  la quarta cifra (cl) in modo da ottenere un numero composto dalle 2 cifre inserite
   
                                ; ax = secondo numero | bx = primo numero
                                
condi:  cmp ax,bx               ; Comparo ax e bx
        je finec                ; Se sono uguali mi reco alla fine del ciclo
        jg amag                 ; se ax ? maggiore di bx si sbosta al blocco di istruzioni 'amag"
        
        sub bx,ax               ; se bx ? maggiore di ax eseguo bx = bx-ax  
        
        jmp condi               ; finita la procedura ritorna all'inizio del ciclo
        
amag:   sub ax,bx               ; Essendo ax maggiore di bx eseguo ax = ax-bx
        
        jmp condi               ; Finita la procedura ritorna all'inizio del ciclo
        
        
finec:  mov ah,09h              ; fine il ciclo 
        mov dx,offset str1      ; Stampo il messaggio di output
        int 21h
        
        mov ax,bx               ; Predispondo il dividendo
        
        mov dl, 10              ; Predispongo il divisore
        div dl                  ; Eseguo la divisione al=ax / 10 salvando il resto in ah
                                ; ottenendo le due cifre che compongolo L'MCD (cifre decimali) 
        
        mov dx,ax               ; Sposto tutto il registo ax(ah e al) in dx
        
        
        add dl,30h              ; Rendo le cifre numeriche dell'MCD caratteri
        add dh,30h              ; aggiungendo 30h in modo da poterli stampare
        
        mov ah,02h              ; Predispongo l'output di un carattere
        int 21h                 ; chiamo l'interrupt DOS | verra effettuata la stampa di dl che contiene gi? la prima cifra dell\'MCD
        mov dl,dh               ; Sposto la seconda cifra dell'MCD in dl
        int 21h                 ; Chiamo l'interrupt DOS
        
        
        mov ah,09h               
        mov dx,offset exit      ; Stampo il messaggio attesa per l'arresto del programma
        int 21h
        
        mov ah,01h              ; Utilizzo una richiesta di input per simulare un \"Premere un tasto per continuare\"
        int 21h                                   
                     
     
fineprg:mov ah,4Ch      ; ah = 4Ch (Fine esecuzione Assembly)
        int 21h         ; chiamata all'interrupt DOS
END                     ; fine del programma 