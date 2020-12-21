include win64a.inc

DATA1 STRUCT
number_1 dd ?
number_2 dd ?
number_3 dd ?
DATA1 ENDS

.data
element_1 DATA1 <2.2,3.3,4.4>
element_2 dd 5.5,6.6,7.7
len2 equ ($-element_2)/type element_2
temp1 real4 ?
temp2 real4 ?
temp3 real4 ?
result_1 real8 3 dup(0.0)
result_2 real8 3 dup(0.0)
tFpu dq 0
tSse dq 0

title1 db "masm64.",0
text db "В одной программе произвести расчеты уравнения (a/c)bd  при помощи команд сопроцессора и команд  технологии SSE.",0ah,
"Сравнить и вывести время выполнения уравнения командами разных технологий.",0ah, 
"Pезультат через SSE: %d,%d,%d. Число тиков SSE = %d.",0ah,
"Pезультат через FPU: %d,%d,%d. Число тиков FPU = %d.",0ah,
"Автор - Владислав Греков, КИТ-37",0
buf real4 len2 dup(?)

.code
WinMain proc
sub rsp,28h
mov rbp,rsp 

rdtsc
xchg r14,rax 
finit
mov rcx,len2
lea r10,result_2
lea rsi,element_2
m1:
fld dword ptr [rsi]
fdiv element_1.number_2
fmul element_1.number_1
fmul element_1.number_3
fisttp qword ptr [r10]
add rsi,type element_2
add r10,8
loop m1
rdtsc
sub rax,r14
mov tFpu,rax

rdtsc
xchg r14,rax 
mov rcx,len2
lea rdx,result_1
lea rbx,element_2
movss xmm0,element_1.number_1
movss xmm1,element_1.number_2
movss xmm2,element_1.number_3
mulss xmm0,xmm2
@@:
movss xmm3,dword ptr[rbx]
divss xmm3,xmm1
mulss xmm3,xmm0
cvtss2si rax,xmm3
mov [rdx],rax
add rbx,type element_2
add rdx,8
loop @b
rdtsc
sub rax,r14
mov tSse,rax

invoke wsprintf,addr buf,addr text,result_1[0],result_1[8],result_1[16],tSse,result_2[0],result_2[8],result_2[16],tFpu
invoke MessageBox,0,addr buf,addr title1,MB_ICONINFORMATION;
invoke ExitProcess,0 
WinMain endp
end
