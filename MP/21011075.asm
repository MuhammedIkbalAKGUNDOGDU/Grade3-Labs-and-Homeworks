ortaksg SEGMENT PARA 'ortak'
                                    ORG    100h
                                    ASSUME DS:ortaksg, CS:ortaksg, SS:ortaksg
    Basla:                          
                                    JMP    HIPO

    i                               DB     1
    j                               DB     1
    temp2                           DW     0
    temp                            DW     0                                     ; temp için 16 bitlik alan
    primeOddSum                     DB     20 DUP(9)
    nonPrimeOrEvenSum               DB     20 DUP(9)
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
                                    MOV    BX, 1
    SquareControl:                  
                                    CMP    BL, 51
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
                                    XOR    DX, DX                                ; DX'i sıfırla

                                    CMP    AX , 1
                                    JE     jumphelper
                                    CMP    AL,2
                                    JE     notprime
                                    
                                    MOV    AX,temp                               ;AX HİPOTENUS
                                    XOR    DX, DX                                ; DX'i sıfırla
                                    MOV    CL,2
                                    DIV    CL                                    ;
                                    CMP    DX,0
                                    JE     notprime
                                    MOV    BL, 3
    EndSquareControlTrueLOOP:       
                                    
                                    CMP    BL, 50                                ; al < 50 kontrolü
                                    JAE    prime                                 ; Eğer al >= 50 ise iç döngüden çık

                                    DIV    BL
                                   

                                    ADD    BL ,2
                                    CMP    AH,0
                                    MOV    AX,temp
                                    JE     notprime

                                    JMP    EndSquareControlTrueLOOP
                          
    ;burada kaldın ikbal
    jumphelper:                     JMP    EndSquareControlFALSE
    loophelper:                     JMP    EndInnerLoop
    loophelper2:                    JMP    EndOuterLoop
    prime:                                                                       ;i ve j toplamı tek ise oddprime değilse nonoddprimeye eklenecek
                                    XOR    AX,AX
                                    MOV    AL,i
                                    MOV    BL,j
                                    ADD    AL,BL
                                    XOR    DX, DX                                ; DX'i sıfırla

                                    MOV    CL ,2
                                    DIV    CL
                                    CMP    AH,1
                                    JNE    notprime
    ;BURADAN SONRA HEM İ + J TEK HEMDE HİPOTENUS OKEY O YÜZDEN ODDPRİME DİZİSİNE EKLEMEY OLACAK------------------
                                    MOV    SI, 0
                                    XOR    AX,AX
                                    MOV    AL, indexCount[SI]
                                    MOV    SI, 0

    oddprimeControl:                
                                    MOV    DX, temp
                                    CMP    primeOddSum[SI],DL
                                    JE     find
                                    CMP    SI,AX
                                    JGE    notfindoddprime
                                    INC    SI
                                    JMP    oddprimeControl
                            
    notprime:                                                                    ;direkt diziye yerleştirme
                                    MOV    SI, 1
                                    XOR    AX,AX
                                    MOV    AL, indexCount[SI]
                                    MOV    SI, 0

    nonPrimeOrEvenSumcONTROL:       MOV    DX, temp
                                    CMP    nonPrimeOrEvenSum[SI],DL
                                    JE     find
                                    CMP    SI,AX
                                    JGE    notfindnonprimeorevensumcontrol
                                    INC    SI
                                    JMP    nonPrimeOrEvenSumcONTROL

    notfindoddprime:                
                                    MOV    DX, temp
                                    MOV    primeOddSum[SI],DL
                                    MOV    SI,0
                                    INC    indexCount[SI]

    notfindnonprimeorevensumcontrol:
                                    MOV    DX, temp
                                    MOV    nonPrimeOrEvenSum[SI],DL
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
