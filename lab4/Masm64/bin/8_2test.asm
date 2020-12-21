include win64a.inc
.data
stdout dd 0 ;
stdin dd 0 ;
rdn dd 0 ;
wrtn dd 0 ;
msg db "Enter symbol:"
MSIZE equ $ - msg ;
symbol db "1" ;
buff db 0 ;
Msg1 db "Пароль совпал",0
Msg2 db "Пароль не корректен",0
Title1 db "Проверка пароля",0
.code
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp
invoke GetStdHandle,STD_INPUT_HANDLE ; извлекает дескриптор устр. ввода
mov stdin,eax ; сохранение дескриптора ввода
invoke GetStdHandle,STD_OUTPUT_HANDLE ; извлекает дескриптор устр. вывода
mov stdout,eax ; сохранение дескриптора вывода
; записывает символьную строку в экранный буфер консоли
invoke WriteConsole,stdout,offset msg,MSIZE,offset wrtn,0
invoke ReadConsole,stdin,offset buff,1,offset rdn, 0
mov al,byte ptr [buff]
cmp al,symbol
jnz _exit
invoke MessageBox,0,addr Msg1,addr Title1,MB_OK
jmp exit2
_exit:
invoke MessageBox,0,addr Msg2,addr Title1,MB_OK
exit2: invoke RtlExitUserProcess,0 ;ExitProcess,0
WinMain endp
end