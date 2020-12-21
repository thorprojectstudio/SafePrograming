include win64a.inc ; подключаемые библиотеки
.data
mas1 dq 1.,2.,3. ; массив 1
mas2 dq 8.,3.,4. ; массив 2
len equ ($-mas2)/ type mas2 ; количество чисел массива mas2

titl1 db "SSE2-команды. Параллельный поиск max значений в массивах",0 ; название окна
fmt db "Выполнить параллельное сравнение массивов по 3-и 64-разрядных вещественных числа",0Ah,\
"в парах упакованных 64-разрядных чисел с плавающей точ-кой.",0Ah,0Dh,
"Если все числа второго массива больше первого, то выполнить поиск максимального значения,",0Ah,
"а если наоборот – то минимального.",0Ah,
"Результат = %d",10,
"Автор: Хижняк O.С., КIТ-37",0
buf1 dq 0 ; буфер
.code

WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 - возврат
mov rbp,rsp

mov rax,len ;
mov rbx,2 ; количество 32-разрядных чисел в 128-разрядном регистре
xor rdx,rdx ;
div rbx ; определение количества циклов для параллельного считывания и остатка
mov ecx,eax ; счетчик циклов для параллельного считывания
lea rsi,mas1 ;
lea rdi,mas2 ; 
next: 
movups XMM0,xmmword ptr [rsi]; 4- 32 числа из mas1
movups XMM1,[rdi] ; 4- 32 числа из mas2
cmpltps XMM0,XMM1 ; сравнение на меньше: если меньше, то нули
movmskps rbx,XMM0 ; перенесение знаковых битов
add rsi,16 ; подготовка адреса для нового считывания mas1
add rdi,16 ; подготовка адреса для нового считывания mas2
dec rcx ; уменьшение счетчика циклов
jnz m1 ; проверка счетчика на ненулевое значение
jmp m2 ;
m1: mov r10,rbx
shl r10,4 ; сдвиг налево на 4 бита
jmp next ; на новый цикл
m2: cmp rdx,0 ; проверка остатка
jz _end ;
mov rcx,rdx ; если в остатке не нуль, то установка счетчика
m4:
movss XMM0,dword ptr[rsi] ;
movss XMM1,dword ptr[rdi] ;
comiss XMM0,XMM1 ; сравнение младших чисел массивов
jg @f ; если больше
shl r10,1 ; сдвиг влево на 1 разряд
inc r10 ; встановление 1, поскольку XMM0[0] < XMM1[0]
jmp m3
@@:
shl r10,1 ; сдвиг налево на 1 разряд
m3:
add rsi,4 ; адреса для нового числа mas1
add rdi,4 ; адреса для нового числа mas2
loop m4
_end: 

cmp r10,0 ; проверка знаковых битов
jz x2 ; если ebx = 0, то перейти на метку mb
jnz x1
x1:

movupd Xmm2,mas1 ; занесение masl к ХММО
movupd Xmm3,mas2 ; занесение mas2 к Хмм1
maxpd Xmm2,xmm3 ; нахождение максимумов в mas1 и mas2
unpckhpd xmm6,xmm2 ; распаковка ст. ч. xmm0 в ст. ч. xmm4 и сдвиг мл. ч. xmm4
unpckhpd xmm6,xmm7 ; перемещение ст. части xmm4 в мл. ч. xmm4
unpcklpd xmm7,xmm2 ; распаковка мл. ч. xmm0 в ст. ч. xmm5 и сдвиг мл. ч. xmm5
unpckhpd xmm7,xmm8 ; перемещение ст. части xmm5 в мл. часть xmm5
unpckhpd xmm8,xmm2 ; перемещение ст. части xmm5 в мл. часть xmm5
unpckhpd xmm8,xmm9 ; перемещение ст. части xmm5 в мл. часть xmm5

cvtpd2pi MM0,xmm7 ; превращение в 32-разрядное число
movd dword ptr ebx,mm0 ; занесение содержимого ММ0 в ebx
x2:
movupd Xmm2,mas1 ; занесение masl к ХММО
movupd Xmm3,mas2 ; занесение mas2 к Хмм1
minpd Xmm2,xmm3 ; нахождение максимумов в mas1 и mas2
unpckhpd xmm6,xmm2 ; распаковка ст. ч. xmm0 в ст. ч. xmm4 и сдвиг мл. ч. xmm4
unpckhpd xmm6,xmm7 ; перемещение ст. части xmm4 в мл. ч. xmm4
unpcklpd xmm7,xmm2 ; распаковка мл. ч. xmm0 в ст. ч. xmm5 и сдвиг мл. ч. xmm5
unpckhpd xmm7,xmm8 ; перемещение ст. части xmm5 в мл. часть xmm5
unpckhpd xmm8,xmm2 ; перемещение ст. части xmm5 в мл. часть xmm5
unpckhpd xmm8,xmm9 ; перемещение ст. части xmm5 в мл. часть xmm5

cvtpd2pi MM0,xmm7 ; превращение в 32-разрядное число
movd dword ptr ebx,mm0 ; занесение содержимого ММ0 в
invoke wsprintf,addr buf1,addr fmt,ebx ; преобразование
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION+90000h
invoke ExitProcess,0
WinMain endp
end
