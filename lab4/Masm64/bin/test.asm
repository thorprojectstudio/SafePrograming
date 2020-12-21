; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    includelib \pasm64\lib64\kernel32.lib
    includelib \pasm64\lib64\user32.lib

    MessageBoxA PROTO :QWORD,:QWORD,:QWORD,:QWORD
    MessageBox equ <MessageBoxA>
    ExitProcess PROTO :QWORD

    call_msgbox PROTO :QWORD,:QWORD,:QWORD,:QWORD

    MB_OK equ <0>

  .data
    tmsg db "POASM 64 bit MessageBox",0
    titl db "POASM 64 bit",0
    msg2 db "Called from a POASM 64 bit procedure",0
    ttl2 db "'call_msgbox' proc here",0

  .code

align 16
start:

    xor rax, rax
    sub rsp, 40     ; 28h
    invoke MessageBox,rax,ADDR tmsg,ADDR titl,MB_OK

    xor rax, rax
    sub rsp, 40     ; 28h
    invoke call_msgbox,rax,ADDR msg2,ADDR ttl2,MB_OK

    xor rax, rax
    sub rsp, 8
    invoke ExitProcess,rax

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

align 16

call_msgbox proc hndl:QWORD,txt:QWORD,ttl:QWORD,styl:QWORD

    invoke MessageBox,hndl,txt,ttl,styl

    ret

call_msgbox endp

; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

end start
