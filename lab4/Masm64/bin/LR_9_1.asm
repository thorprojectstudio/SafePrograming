 ;Если все числа второго массива больше первого, то сложить все числа второго массива, а если наоборот – то первого.

include win64a.inc
.data
mas1 dd -1.3, 2.1, 4.8, 1.0
mas2 dd -1., -5.0,-3.54,1.5
len equ ($-mas2)/ type mas2 ; количество чисел массива mas2
a1 dd 3.0 ;
b1 dd 0.2 ;
c1 dd 1.0 ;
d1 dd 2.2 ;
fmt db "Результат = %d",10,10,"Автор: Хижняк O.С., КIТ-37, НТУ ХПИ",0
titl1 db "masm64. Параллельное сравнение с помощью SSE-команд",0; название окошка
buf1 dq 0,0
.code
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 - возврат
mov rbp,rsp
mov eax,len ;
mov ebx,4 ; количество 32-разрядных чисел в 128-разрядном регистре
xor edx,edx ;
div ebx ; определение количества циклов для параллельного считывания и остатка
mov ecx,eax ; счетчик циклов для параллельного считывания
lea rsi,mas1 ;
lea rdi,mas2 ; 
next: 
movups XMM0,xmmword ptr [rsi]; 4- 32 числа из mas1
movups XMM1,[rdi] ; 4- 32 числа из mas2
cmpltps XMM0,XMM1 ; сравнение на меньше: если меньше, то нули
movmskps ebx,XMM0 ; перенесение знаковых битов
add rsi,16 ; подготовка адреса для нового считывания mas1
add rdi,16 ; подготовка адреса для нового считывания mas2
dec ecx ; уменьшение счетчика циклов
jnz m1 ; проверка счетчика на ненулевое значение
jmp m2 ;
m1: mov r10,rbx
shl r10,4 ; сдвиг налево на 4 бита
jmp next ; на новый цикл
m2: cmp edx,0 ; проверка остатка
jz _end ;
mov ecx,edx ; если в остатке не нуль, то установка счетчика
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
jz x1 ; если ebx = 0, то перейти на метку mb
jnz x2
x1:
movaps XMM0,mas1 ; XMM0:= 4. 3. 2. 1.
movaps XMM1,XMM0 ; XMM1:= 4. 3. 2. 1.
shufps XMM1,XMM1,11111001b ; XMM1:= 4. 4. 3. 2.
addss XMM0,XMM1 ; XMM0:= 4. 3. 2. 3.
shufps XMM1,XMM1,11111001b ; XMM1:= 4. 4. 4. 3.
addss XMM0,XMM1 ; XMM0:= 4. 3. 2. 6.
shufps XMM1,XMM1,11111001b ; XMM1:= 4. 4. 4. 4.
addss XMM0,XMM1 ; XMM0:= 4. 3. 2. 10.
cvttss2si eax,xmm0
movsxd r15,eax
jmp exit
x2:
movaps XMM2,mas2 ; XMM0:= 4. 3. 2. 1.
movaps XMM3,XMM2 ; XMM1:= 4. 3. 2. 1.
shufps XMM3,XMM3,11111001b ; XMM1:= 4. 4. 3. 2.
addss XMM2,XMM3 ; XMM0:= 4. 3. 2. 3.
shufps XMM3,XMM3,11111001b ; XMM1:= 4. 4. 4. 3.
addss XMM2,XMM3 ; XMM0:= 4. 3. 2. 6.
shufps XMM3,XMM3,11111001b ; XMM1:= 4. 4. 4. 4.
addss XMM2,XMM3 ; XMM0:= 4. 3. 2. 10.
cvttss2si eax,xmm0
movsxd r15,eax
exit:

invoke wsprintf,addr buf1,addr fmt,r15
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION
invoke ExitProcess,0
WinMain endp
end