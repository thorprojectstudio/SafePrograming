; masm64. AVX-команды.
; Умножение массивов чисел командой vpmaddwd
include win64a.inc
.data
a1 dd 9999,9992,9993,9994,9995,9996,9997,9998,9999,9990,9991,9992,9993,9994,9995,9996,9997,9998 ;18 чисел
b1 dd 9999,8998,8994,9899,9799,9998,9999,10990,10991,10992,10993,10994,10995,19906,10997,19908,10999 ;18 чисел
len1 EQU ($-b1)/type b1
res1 dd 18 dup(0),0
res2 dq len1 dup(0),0

titl db "masm64.Проверка микропроцессора на поддержку команд AVX",0
szInf db "Команды AVX ПОДДЕРЖИВАЮТСЯ!!!",0 ;
inf db "Команды AVX микропроцессором НЕ поддерживаются",0;
tit2 db "masm64.Проверка микропроцессора на поддержку команд AVX2",0
szInf2 db "Команды AVX2 ПОДДЕРЖИВАЮТСЯ!!!",0 ;
inf2 db "Команды AVX2 микропроцессором НЕ поддерживаются",0;

tit1 db "masm64.Приминение команды vpmulhuw",0
buf1 dq len1 dup(0),0

frmt db "Использование команды vpmulhuw:",10,
"9999 9992 9993 9994 9995 9996 9997 9998 9999 9990 9991 9992 9993 9994 9995 9996 9997 9998",10,
"9999 8998 8994 9899 9799 9998 9999 10990 10991 10992 10993 10994 10995 19906 10997 19908 10999",10,10,
" Ответ =", 10 dup(" %d "),10,10,
"Автор: Коваленко В.С.,КИТ-16А, НТУ ХПИ",10,0

.code
WinMain proc
push rbp ; <-- это уже выравнивает стек на 8
sub rsp,30h ; <-- для 7-10 параметров
mov rbp,rsp

; проверка на поддержку AVX команд
mov EAX,1 ; при использования 64-разрядной ОС
cpuid ; по содержимому eax производится идентификация микропроцессора
and ecx,10000000h ; eсx:= eсx v 1000 0000h (28 разряд)
jnz exit1 ; перейти, если не нуль
invoke MessageBox,0,addr inf,addr titl,MB_OK
jmp avx2
exit1:
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION

avx2:
; проверка на поддержку AVX2 команд
mov eax,7
mov ecx,0
cpuid ; по содержимому rax производится идентификация МП
and rbx,20h ; (5 разряд)
jnz exit2 ; перейти, если не нуль
invoke MessageBox,0,addr inf2,addr tit2,MB_OK
jmp next
exit2:
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION

next:
mov rax,len1 ;
mov rbx,8 ; 16 х 8 = 128
xor rdx,rdx  ; подготовка к делению
div rbx ; определение количества циклов в rax и остатка в rdx
mov rcx,rax   ; сохранение количества циклов
lea rsi,a1  ; загрузка адреса массива a1
lea rdi,b1    ; загрузка адреса массива b1
lea rbx,res1  ; загрузка адреса массива res1

m1: vmovups xmm0,[rsi]  ; перемещение упакованных чисел одинарной точности
vmovups xmm1,[rdi]      ;
vpmulhuw xmm2, xmm0, xmm1 ;
vmovups [rbx], xmm2  ; перемещение упакованных чисел одинарной точности

add rdi,16 ; 16 х 8 = 128
add rsi,16 ; смещение на 128
add rbx,16 ; смещение на 16 байт = 128 бит
loop m1
cmp rdx,0h ; сравнение остатка с нулем
jz exit ; перейти, если ноль
mov rcx,rdx ; занесение содержимого rdx в счетчик


lea rsi,res1
lea rdi,res2
mov rcx,len1 ; количество чисел, которые выводятся в окно
m5:
movsxd r15,dword ptr [rsi]
mov qword ptr[rdi],r15
add rsi,4
add rdi,8
dec rcx
jnz m5
invoke wsprintf,ADDR buf1,ADDR frmt,res2,res2[8],res2[16],res2[24],res2[32],res2[40],res2[48],res2[56], res2[64], res2[72];
invoke MessageBox,0,ADDR buf1,ADDR tit1,MB_OK
exit: invoke RtlExitUserProcess,0 ;ExitProcess,0
WinMain endp
end
