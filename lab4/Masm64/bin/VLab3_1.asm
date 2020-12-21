; masm64. AVX-�������.
; ��������� �������� ����� �������� vpmaddwd
include win64a.inc
.data
a1 dd 9999,9992,9993,9994,9995,9996,9997,9998,9999,9990,9991,9992,9993,9994,9995,9996,9997,9998 ;18 �����
b1 dd 9999,8998,8994,9899,9799,9998,9999,10990,10991,10992,10993,10994,10995,19906,10997,19908,10999 ;18 �����
len1 EQU ($-b1)/type b1
res1 dd 18 dup(0),0
res2 dq len1 dup(0),0

titl db "masm64.�������� ��������������� �� ��������� ������ AVX",0
szInf db "������� AVX ��������������!!!",0 ;
inf db "������� AVX ���������������� �� ��������������",0;
tit2 db "masm64.�������� ��������������� �� ��������� ������ AVX2",0
szInf2 db "������� AVX2 ��������������!!!",0 ;
inf2 db "������� AVX2 ���������������� �� ��������������",0;

tit1 db "masm64.���������� ������� vpmulhuw",0
buf1 dq len1 dup(0),0

frmt db "������������� ������� vpmulhuw:",10,
"9999 9992 9993 9994 9995 9996 9997 9998 9999 9990 9991 9992 9993 9994 9995 9996 9997 9998",10,
"9999 8998 8994 9899 9799 9998 9999 10990 10991 10992 10993 10994 10995 19906 10997 19908 10999",10,10,
" ����� =", 10 dup(" %d "),10,10,
"�����: ��������� �.�.,���-16�, ��� ���",10,0

.code
WinMain proc
push rbp ; <-- ��� ��� ����������� ���� �� 8
sub rsp,30h ; <-- ��� 7-10 ����������
mov rbp,rsp

; �������� �� ��������� AVX ������
mov EAX,1 ; ��� ������������� 64-��������� ��
cpuid ; �� ����������� eax ������������ ������������� ���������������
and ecx,10000000h ; e�x:= e�x v 1000 0000h (28 ������)
jnz exit1 ; �������, ���� �� ����
invoke MessageBox,0,addr inf,addr titl,MB_OK
jmp avx2
exit1:
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION

avx2:
; �������� �� ��������� AVX2 ������
mov eax,7
mov ecx,0
cpuid ; �� ����������� rax ������������ ������������� ��
and rbx,20h ; (5 ������)
jnz exit2 ; �������, ���� �� ����
invoke MessageBox,0,addr inf2,addr tit2,MB_OK
jmp next
exit2:
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION

next:
mov rax,len1 ;
mov rbx,8 ; 16 � 8 = 128
xor rdx,rdx  ; ���������� � �������
div rbx ; ����������� ���������� ������ � rax � ������� � rdx
mov rcx,rax   ; ���������� ���������� ������
lea rsi,a1  ; �������� ������ ������� a1
lea rdi,b1    ; �������� ������ ������� b1
lea rbx,res1  ; �������� ������ ������� res1

m1: vmovups xmm0,[rsi]  ; ����������� ����������� ����� ��������� ��������
vmovups xmm1,[rdi]      ;
vpmulhuw xmm2, xmm0, xmm1 ;
vmovups [rbx], xmm2  ; ����������� ����������� ����� ��������� ��������

add rdi,16 ; 16 � 8 = 128
add rsi,16 ; �������� �� 128
add rbx,16 ; �������� �� 16 ���� = 128 ���
loop m1
cmp rdx,0h ; ��������� ������� � �����
jz exit ; �������, ���� ����
mov rcx,rdx ; ��������� ����������� rdx � �������


lea rsi,res1
lea rdi,res2
mov rcx,len1 ; ���������� �����, ������� ��������� � ����
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
