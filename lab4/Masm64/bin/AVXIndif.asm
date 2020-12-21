include win64a.inc  ;  подключаемые библиотеки
.data
titl db "masm64.Проверка микропроцессора на поддержку команд AVX",0
szInf db "Команды AVX ПОДДЕРЖИВАЮТСЯ!!!",0 ;
inf db "Команды AVX микропроцессором НЕ поддерживаются",0;
tit2 db "masm64.Проверка микропроцессора на поддержку команд AVX2",0
szInf2 db "Команды AVX2 ПОДДЕРЖИВАЮТСЯ!!!",0 ;
inf2 db "Команды AVX2 микропроцессором НЕ поддерживаются",0;

.code              
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

; проверка на поддержку AVX команд
mov EAX,1 ; при использования 64-разрядной ОС
cpuid ; по содержимому eax производится идентификация микропроцессора
and ecx,10000000h ; eсx:= eсx v 1000 0000h (28 разряд)
jnz exit1 ; перейти, если не нуль
invoke MessageBox,0,addr inf,addr titl,MB_OK
jmp exit
exit1:
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION

; проверка на поддержку AVX2 команд
mov eax,7
mov ecx,0
cpuid ; по содержимому rax производится идентификация МП
and rbx,20h ; (5 разряд)
jnz exit2 ; перейти, если не нуль
invoke MessageBox,0,addr inf2,addr tit2,MB_OK
jmp exit
exit2:
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION

exit: invoke RtlExitUserProcess,0
WinMain endp
end
