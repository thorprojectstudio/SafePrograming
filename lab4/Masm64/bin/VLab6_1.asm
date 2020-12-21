; masm64. ����� � �{a1,a2,a3,a4} ������ ��������
; � ����� ����������� Real8. ��������� ��������� ab + c/d - sqrt(e)
include win64a.inc  ;  ������������ ����������

_WQ segment READ WRITE EXECUTE alias("KVS")
; ��������� ab + c/d - sqrt(e)
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 � �������
mov rbp,rsp

mov rcx,225h; ����, ��� ����������/������������ 81 �����
mov rax,$+15h ; ������ � rax ����� ������� ����� ��� �����
mov bl,1Ch ; ������ ����� � rbx
lp:
 xor byte ptr [rax],bl ; ���������� �������� xor � ������
 not bl; ������ ���� (�������� ������ �������� �����)
 inc rax ; ��������� �� ��������� ����
loop lp

mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 � b � ��������� real8
vmovsd xmm2,mas2[8]    ; xmm2 � c
vmovsd xmm3,mas2[16]   ; xmm3 � d
vmovsd xmm4,mas2[24]   ; xmm4 � e
vdivsd xmm3,xmm2,xmm3  ; d/a
vsqrtsd xmm4,xmm4,xmm4 ; sqrt(e)
vsubsd xmm4,xmm3,xmm4  ; d/a - sqrt(e)
b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 � a
vmulsd xmm5,xmm0,xmm1 ; a*b
vcvttsd2si eax,xmm5   ; ��������������� 64-���������� � 32-��������� �����
vaddsd xmm5,xmm5,xmm4 ; ab + c/d - sqrt(e)
vcvttsd2si eax,xmm5   ; ��������������� 64-���������� � 32-��������� �����
movsxd r15,eax        ; ���������� ����������� �� 64-�
mov [rdx],eax         ; ���������� ����������
add rbx,8             ; �������� ��� ������� arr1 (��� ����� �)
add rdx,8             ; �������� ��� ������� �����������
dec rcx
jnz b1 ; ������ �� ���������� ����� b1 (������)
invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16],res[24]
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke RtlExitUserProcess,0 ; ExitProcess,0
WinMain endp

mas1 real8 1.,2.,3.,4. ; ������ ����� �
len1 equ ($-mas1)/type mas1
mas2 real8 2.,20.,5.,25.         ; b, c, d, e
tit1 db 'masm64. AVX. ��������� ���������� ��������� ab + c/d - sqrt(e).',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; ����� ������ ���������

ifmt db 'masm64.  ������ ai = 1., 2., 3., 4.',10,
9,'�����: b, c, d, e  := 2., 20., 5., 25.',10,
'���������� ����������: %d ,%d ,%d ,%d ',10,10,
'�����: ��������� �.�.,���-16A, ��� ���',10,0


_WQ ends
end