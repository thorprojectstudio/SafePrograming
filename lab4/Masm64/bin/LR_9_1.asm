 ;���� ��� ����� ������� ������� ������ �������, �� ������� ��� ����� ������� �������, � ���� �������� � �� �������.

include win64a.inc
.data
mas1 dd -1.3, 2.1, 4.8, 1.0
mas2 dd -1., -5.0,-3.54,1.5
len equ ($-mas2)/ type mas2 ; ���������� ����� ������� mas2
a1 dd 3.0 ;
b1 dd 0.2 ;
c1 dd 1.0 ;
d1 dd 2.2 ;
fmt db "��������� = %d",10,10,"�����: ������ O.�., �I�-37, ��� ���",0
titl1 db "masm64. ������������ ��������� � ������� SSE-������",0; �������� ������
buf1 dq 0,0
.code
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 - �������
mov rbp,rsp
mov eax,len ;
mov ebx,4 ; ���������� 32-��������� ����� � 128-��������� ��������
xor edx,edx ;
div ebx ; ����������� ���������� ������ ��� ������������� ���������� � �������
mov ecx,eax ; ������� ������ ��� ������������� ����������
lea rsi,mas1 ;
lea rdi,mas2 ; 
next: 
movups XMM0,xmmword ptr [rsi]; 4- 32 ����� �� mas1
movups XMM1,[rdi] ; 4- 32 ����� �� mas2
cmpltps XMM0,XMM1 ; ��������� �� ������: ���� ������, �� ����
movmskps ebx,XMM0 ; ����������� �������� �����
add rsi,16 ; ���������� ������ ��� ������ ���������� mas1
add rdi,16 ; ���������� ������ ��� ������ ���������� mas2
dec ecx ; ���������� �������� ������
jnz m1 ; �������� �������� �� ��������� ��������
jmp m2 ;
m1: mov r10,rbx
shl r10,4 ; ����� ������ �� 4 ����
jmp next ; �� ����� ����
m2: cmp edx,0 ; �������� �������
jz _end ;
mov ecx,edx ; ���� � ������� �� ����, �� ��������� ��������
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
jz x1 ; ���� ebx = 0, �� ������� �� ����� mb
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