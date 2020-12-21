; masm64. ����� � �{a1,a2,a3,a4} ������ ��������
; � ����� ����������� Real8. ��������� ��������� � * sqrt(de) + d/a
include win64a.inc  ;  ������������ ����������

_MALEX segment READ WRITE EXECUTE alias("MAI")

;1576
;1752/176

; ��������� � * sqrt(de) + d/a
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 � �������
mov rbp,rsp

mov rcx, 58h; ����, ��� ����������/������������ 81 �����
mov rax,$+1Dh ; ������ � rax ����� ������� ����� ��� �����
mov rbx,0B ; ������ ����� � rbx
lp:
rol word ptr [rax],11
inc rax ; ��������� �� ��������� ����
inc rax
loop lp


mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 � c � ��������� real8
vmovsd xmm2,mas2[8]    ; xmm2 � d
vmovsd xmm3,mas2[16]   ; xmm3 � e
vmulsd xmm3,xmm2,xmm3  ; d*e
vsqrtsd xmm3,xmm3,xmm3 ; sqrt(de)
vmulsd xmm1,xmm1,xmm3  ; c* sqrt(de)
b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 � a
vdivsd xmm4,xmm2,xmm0 ; d/a
vcvttsd2si eax,xmm4   ; ��������������� 64-���������� � 32-��������� �����
vaddsd xmm4,xmm1,xmm4 ; � * sqrt(de) + d/a
vcvttsd2si eax,xmm4   ; ��������������� 64-���������� � 32-��������� �����
movsxd r15,eax        ; ���������� ����������� �� 64-�
mov [rdx],eax         ; ���������� ����������
add rbx,8             ; �������� ��� ������� arr1 (��� ����� �)
add rdx,8             ; �������� ��� ������� �����������
dec rcx
jnz b1 ; ������ �� ���������� ����� b1 (������)
invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16],res[24]
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
WinMain endp

mas1 real8 1.,2.,4.,6. ; ������ ����� �
len1 equ ($-mas1)/type mas1
mas2 real8 4.,36.,1.         ; c, d, e
tit1 db 'masm64. AVX. ��������� ���������� ��������� � * sqrt(de) + d/a.',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; ����� ������ ���������

ifmt db 'masm64.  ������ ai = 1., 2., 4., 6.',10,
9,'�����: c, d, e  := 4., 36., 1.',10,
'���������� ����������: %d ,%d ,%d ,%d ',10,10,
'�����: ��������� �.,���-16�, ��� ���',10,0


_MALEX ends
end
