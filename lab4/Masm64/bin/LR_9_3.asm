include win64a.inc ; подключаемые библиотеки
.data
arr1 real8 16.,25.,36.,1244.
len1 equ ($-arr1)/type arr1
arr2 real8 2.,4.,16.
title1 db "masm64.AVX",0
res dq len1 DUP(0),0
buf1 dd len1 DUP(0),0
text db "Array ai = 16.,25.,36.,1244.",10,
"Numbers: b, c, d := 2.,4.,16.",10,
"Result of counting:%d %d %d %d ",10,10,
"Author: Grekov Vladislav, KIT-37",0
title2 db "Проверка микропроцессора на поддержку AVX команд",0
szInf2 db "Команды AVX микропроцессором НЕ поддерживаются",0

.code
WinMain proc
sub rsp,28h
mov rbp,rsp

mov rcx,len1
lea rdx,res
lea rbx,arr1
vmovsd xmm1,arr1[0];b
vmovsd xmm2,arr1[8];c
vmovsd xmm3,arr1[16];d
vdivsd xmm2,xmm2,xmm3
@@:
vmovsd xmm0,qword ptr [rbx]
vmulsd xmm0,xmm0,xmm1
vaddsd xmm0,xmm0,xmm2
vcvttsd2si eax,xmm0
movsxd r15,eax
mov[rdx],eax
add rbx,8
add rdx,8
dec rcx
jnz @b

invoke wsprintf,addr buf1,addr text,r15
invoke MessageBox,addr buf1,addr title1,MB_ICONINFORMATION
invoke ExitProcess,0
WinMain endp
end