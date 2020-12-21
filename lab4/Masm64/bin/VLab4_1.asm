; masm64. ����� � �{a1,a2,a3,a4} ������ ��������
; � ����� ����������� Real8. ��������� ��������� ab + c/d - sqrt(e)
include win64a.inc  ;  ������������ ����������
.data
mas1 real8 1.,2.,3.,4. ; ������ ����� �
len1 equ ($-mas1)/type mas1
mas2 real8 2.,20.,5.,25.         ; b, c, d, e
tit1 db 'masm64. AVX. ��������� ���������� ��������� ab + c/d - sqrt(e).',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; ����� ������ ���������


titl db "masm64.�������� ��������������� �� ��������� ������ AVX",0
szInf db "������� AVX ��������������!!!",0 ;
inf db "������� AVX ���������������� �� ��������������",0;
tit2 db "masm64.�������� ��������������� �� ��������� ������ AVX2",0
szInf2 db "������� AVX2 ��������������!!!",0 ;
inf2 db "������� AVX2 ���������������� �� ��������������",0;


ifmt db 'masm64.  ������ ai = 1., 2., 3., 4.',10,
9,'�����: b, c, d, e  := 2., 20., 5., 25.',10,
'���������� ����������: %d ,%d ,%d ,%d ',10,10,
'�����: ��������� �.�.,���-16A, ��� ���',10,0

.code               ; ��������� ab + c/d - sqrt(e)
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 � �������
mov rbp,rsp

; �������� �� ��������� AVX ������
mov EAX,1 ; ��� ������������� 64-��������� ��
cpuid ; �� ����������� eax ������������ ������������� ���������������
and ecx,10000000h ; e�x:= e�x v 1000 0000h (28 ������)
jnz exit1 ; �������, ���� �� ����
invoke MessageBox,0,addr inf,addr titl,MB_OK
jmp exit
exit1:
invoke MessageBox,0,addr szInf,addr titl,MB_ICONINFORMATION

; �������� �� ��������� AVX2 ������
mov eax,7
mov ecx,0
cpuid ; �� ����������� rax ������������ ������������� ��
and rbx,20h ; (5 ������)
jnz exit2 ; �������, ���� �� ����
invoke MessageBox,0,addr inf2,addr tit2,MB_OK
jmp run
exit2:
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION

run:
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
exit: invoke RtlExitUserProcess,0
WinMain endp
end
