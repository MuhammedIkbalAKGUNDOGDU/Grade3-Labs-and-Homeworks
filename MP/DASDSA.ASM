ortaksg SEGMENT PARA 'ortak'
                                    ORG    100h
                                    ASSUME DS:ortaksg, CS:ortaksg, SS:ortaksg
    Basla:                          
                                    JMP    HIPO

    i                               DB     1
    j                               DB     1
    temp2                           DW     0
    temp                            DW     0                                     ; temp için 16 bitlik alan
    primeOddSum                     DB     15 DUP(1)
    nonPrimeOrEvenSum               DB     15 DUP(1)
    indexCount                      DB     0,0
    control                         DB     0

HIPO PROC NEAR
                                    XOR    SI, SI
    ; i = 1
                                    MOV    i, 1

    OuterLoop:                                                                   ; for(i = 1; i < 50; i++)
                                    MOV    AL, i
                                    CMP    AL, 50                                ; i < 50 kontrolü
                                    JGE    loophelper2                           ; Eğer i >= 50 ise dış döngüden çık


    ; j = 1
                                    MOV    j, 1

    InnerLoop:                                                                   ; for(j = 1; j < 50; j++)
                                    MOV    AL, j
                                    CMP    AL, 50                                ; j < 50 kontrolü
                                    JGE    loophelper                            ; Eğer j >= 50 ise iç döngüden çık

    ; i * i hesapla
                                    MOV    AL, i
                                    CBW                                          ; AL'deki değeri işaret genişletme için kullanıyoruz
                                    MUL    AL                                    ; AX = i * i
                                    MOV    BX, AX                                ; BX = i * i

    ; j * j hesapla
                                    MOV    AL, j
                                    CBW                                          ; AL'deki değeri işaret genişletme için kullanıyoruz
                                    MUL    AL                                    ; AX = j * j
                                    ADD    AX, BX                                ; AX = i * i + j * j

    ; Sonucu temp'e kaydet
                                    MOV    temp,  AX
                                    MOV    BL, 1
    SquareControl:                  
                                    CMP    BL, 50
                                    MOV    AL,BL                                 ; al < 50 kontrolü
                                    JAE    jumphelper                            ; Eğer al >= 50 ise iç döngüden çık
                                    MUL    AL

                                    CMP    AX , temp
                                    JE     EndSquareControlTrue                  ; Eğer AL == temp ise EndSquareControlTrue etiketine git
                                    INC    BL
                                    JMP    SquareControl                         ; Değilse SquareControl etiketine git
                                    
    EndSquareControlTrue:           
                                    MOV    temp , BX                             ;BX HİPOTENUS
                                    MOV    AX ,temp
                                    CMP    AX , 1
                                    JE     jumphelper
                                    CMP    AL,2
                                    JE     notprime
                                    
                                    MOV    AX,temp                               ;AX HİPOTENUS
                                    MOV    CL,2
                                    DIV    CL                                    ;
                                    CMP    DX,0
                                    JE     notprime
    EndSquareControlTrueLOOP:       
                                    MOV    BL, 3
                                    CMP    BL, 50                                ; al < 50 kontrolü
                                    JAE    prime                                 ; Eğer al >= 50 ise iç döngüden çık

                                    DIV    BL
                                    MOV    AX,temp

                                    INC    BL
                                    INC    BL
                                    JMP    EndSquareControlTrueLOOP
                          
    ;burada kaldın ikbal
    jumphelper:                     JMP    EndSquareControlFALSE
    loophelper:                     JMP    EndInnerLoop
    loophelper2:                    JMP    EndOuterLoop
    prime:                                                                       ;i ve j toplamı tek ise oddprime değilse nonoddprimeye eklenecek
                                    MOV    AL,i
                                    MOV    BX,j
                                    ADD    AL,BX
                                    MOV    AX,AL
                                    MOV    CL ,2
                                    DIV    CL
                                    CMP    AH,1
                                    JNE    notprime
    ;BURADAN SONRA HEM İ + J TEK HEMDE HİPOTENUS OKEY O YÜZDEN ODDPRİME DİZİSİNE EKLEMEY OLACAK------------------
                                    MOV    SI, 0
                                    MOV    AL, indexCount[SI]
                                    MOV    SI 0

    oddprimeControl:                
                                    CMP    primeOddSum[SI],temp
                                    JE     find
                                    CMP    SI,AL
                                    JGE    notfindoddprime
                                    INC    SI
                                    JMP    oddprimeControl
                            
    notprime:                                                                    ;direkt diziye yerleştirme
                                    MOV    SI, 1
                                    MOV    AL, indexCount[SI]
                                    MOV    SI, 0

    nonPrimeOrEvenSumcONTROL:       
                                    CMP    nonPrimeOrEvenSum[SI],temp
                                    JE     find
                                    CMP    SI,AL
                                    JGE    notfindnonprimeorevensumcontrol
                                    INC    SI
                                    JMP    nonPrimeOrEvenSumcONTROL

    notfindoddprime:                
                                    MOV    primeOddSum[SI],temp
                                    MOV    SI,0
                                    INC    indexCount[SI]

    notfindnonprimeorevensumcontrol:
                                    MOV    nonPrimeOrEvenSum[SI],temp
                                    MOV    SI,1
                                    INC    indexCount[SI]
    EndSquareControlFALSE:          
    find:                           
    ; j++ işlemi
                                    INC    j
                                    JMP    InnerLoop                             ; İç döngü başına dön

    EndInnerLoop:                                                                ; İç döngü bittiğinde buraya gelir

    ; i++ işlemi
                                    INC    i
                                    JMP    OuterLoop                             ; Dış döngü başına dön

    EndOuterLoop:                                                                ; Dış döngü bittiğinde buraya gelir
                                    RET
HIPO ENDP
ortaksg ENDS
END Basla
