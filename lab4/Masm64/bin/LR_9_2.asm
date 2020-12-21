include win64a.inc ; ������������ ����������
.data
mas1 dq 1.,2.,3. ; ������ 1
mas2 dq 8.,3.,4. ; ������ 2
len equ ($-mas2)/ type mas2 ; ���������� ����� ������� mas2

titl1 db "SSE2-�������. ������������ ����� max �������� � ��������",0 ; �������� ����
fmt db "��������� ������������ ��������� �������� �� 3-� 64-��������� ������������ �����",0Ah,\
"� ����� ����������� 64-��������� ����� � ��������� ���-���.",0Ah,0Dh,
"���� ��� ����� ������� ������� ������ �������, �� ��������� ����� ������������� ��������,",0Ah,
"� ���� �������� � �� ������������.",0Ah,
"��������� = %d",10,
"�����: ������ O.�., �I�-37",0
buf1 dq 0 ; �����
.code

WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 - �������
mov rbp,rsp

mov rax,len ;
mov rbx,2 ; ���������� 32-��������� ����� � 128-��������� ��������
xor rdx,rdx ;
div rbx ; ����������� ���������� ������ ��� ������������� ���������� � �������
mov ecx,eax ; ������� ������ ��� ������������� ����������
lea rsi,mas1 ;
lea rdi,mas2 ; 
next: 
movups XMM0,xmmword ptr [rsi]; 4- 32 ����� �� mas1
movups XMM1,[rdi] ; 4- 32 ����� �� mas2
cmpltps XMM0,XMM1 ; ��������� �� ������: ���� ������, �� ����
movmskps rbx,XMM0 ; ����������� �������� �����
add rsi,16 ; ���������� ������ ��� ������ ���������� mas1
add rdi,16 ; ���������� ������ ��� ������ ���������� mas2
dec rcx ; ���������� �������� ������
jnz m1 ; �������� �������� �� ��������� ��������
jmp m2 ;
m1: mov r10,rbx
shl r10,4 ; ����� ������ �� 4 ����
jmp next ; �� ����� ����
m2: cmp rdx,0 ; �������� �������
jz _end ;
mov rcx,rdx ; ���� � ������� �� ����, �� ��������� ��������
m4:
movss XMM0,dword ptr[rsi] ;
movss XMM1,dword ptr[rdi] ;
comiss XMM0,XMM1 ; ��������� ������� ����� ��������
jg @f ; ���� ������
shl r10,1 ; ����� ����� �� 1 ������
inc r10 ; ������������ 1, ��������� XMM0[0] < XMM1[0]
jmp m3
@@:
shl r10,1 ; ����� ������ �� 1 ������
m3:
add rsi,4 ; ������ ��� ������ ����� mas1
add rdi,4 ; ������ ��� ������ ����� mas2
loop m4
_end: 

cmp r10,0 ; �������� �������� �����
jz x2 ; ���� ebx = 0, �� ������� �� ����� mb
jnz x1
x1:

movupd Xmm2,mas1 ; ��������� masl � ����
movupd Xmm3,mas2 ; ��������� mas2 � ���1
maxpd Xmm2,xmm3 ; ���������� ���������� � mas1 � mas2
unpckhpd xmm6,xmm2 ; ���������� ��. �. xmm0 � ��. �. xmm4 � ����� ��. �. xmm4
unpckhpd xmm6,xmm7 ; ����������� ��. ����� xmm4 � ��. �. xmm4
unpcklpd xmm7,xmm2 ; ���������� ��. �. xmm0 � ��. �. xmm5 � ����� ��. �. xmm5
unpckhpd xmm7,xmm8 ; ����������� ��. ����� xmm5 � ��. ����� xmm5
unpckhpd xmm8,xmm2 ; ����������� ��. ����� xmm5 � ��. ����� xmm5
unpckhpd xmm8,xmm9 ; ����������� ��. ����� xmm5 � ��. ����� xmm5

cvtpd2pi MM0,xmm7 ; ����������� � 32-��������� �����
movd dword ptr ebx,mm0 ; ��������� ����������� ��0 � ebx
x2:
movupd Xmm2,mas1 ; ��������� masl � ����
movupd Xmm3,mas2 ; ��������� mas2 � ���1
minpd Xmm2,xmm3 ; ���������� ���������� � mas1 � mas2
unpckhpd xmm6,xmm2 ; ���������� ��. �. xmm0 � ��. �. xmm4 � ����� ��. �. xmm4
unpckhpd xmm6,xmm7 ; ����������� ��. ����� xmm4 � ��. �. xmm4
unpcklpd xmm7,xmm2 ; ���������� ��. �. xmm0 � ��. �. xmm5 � ����� ��. �. xmm5
unpckhpd xmm7,xmm8 ; ����������� ��. ����� xmm5 � ��. ����� xmm5
unpckhpd xmm8,xmm2 ; ����������� ��. ����� xmm5 � ��. ����� xmm5
unpckhpd xmm8,xmm9 ; ����������� ��. ����� xmm5 � ��. ����� xmm5

cvtpd2pi MM0,xmm7 ; ����������� � 32-��������� �����
movd dword ptr ebx,mm0 ; ��������� ����������� ��0 �
invoke wsprintf,addr buf1,addr fmt,ebx ; ��������������
invoke MessageBox,0,addr buf1,ADDR titl1,MB_ICONINFORMATION+90000h
invoke ExitProcess,0
WinMain endp
end
