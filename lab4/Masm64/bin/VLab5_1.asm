; masm64. ����� � �{a1,a2,a3,a4} ������ ��������
; � ����� ����������� Real8. ��������� ���������  sqrt(a) * b + c/d/e

include win64a.inc ; ������������ ����������
IDI_ICON EQU 1001 ; ������������� ������
MSGBOXPARAMSA STRUCT
 cbSize DWORD ?,?
 hwndOwner QWORD ?
 hInstance QWORD ?
 lpszText QWORD ?
 lpszCaption QWORD ?
 dwStyle DWORD ?,?
 lpszIcon QWORD ?
 dwContextHelpId QWORD ?
 lpfnMsgBoxCallback QWORD ?
 dwLanguageId DWORD ?,?
MSGBOXPARAMSA ENDS



.data
 params MSGBOXPARAMSA <>
 fileN db "AVXIndif.exe",0

str3 db "Input password:**********",0ah,0
szPas db "Kovalenko",0
szStr1 db "�� ����� ���������� ������.",0
szStr2 db "�� ����� ������������ ������.",0
plen dq sizeof szPas
len3 dq sizeof str3
str0 dq ?
buf dq ? 
consIn dq ?
consOut dq ?
cWriten dq ?

mas1 real8 1.,2.,4.,6.,8. ; ������ ����� �
len1 equ ($-mas1)/type mas1
mas2 real8 4., 2., 8., 10.         ; b, c, d, e
tit1 db 'masm64. AVX. ��������� ���������� ��������� sqrt(a) * b + c/d/e',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; ����� ������ ���������

ifmt db 'masm64.  ������ ai = 1., 2., 4., 6.,8.',10,
9,'�����: b, c, d, e  := 4., 2., 8., 10.',10,
'���������� ����������: %d ,%d ,%d ,%d, %d ',10,10,
'�����: ��������� �.�.,���-16�, ��� ��I',10,0

.code               ; ��������� sqrt(a) * b + c/d/e
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 � �������
mov rbp,rsp

mov ax,02EBh
jmp $ - 2 ; ������� 2 ������ EB 


invoke WinExec,addr fileN, SW_SHOW

; �������� ����������� ����� ������
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consOut, rax
; �������� ����������� ����� �����
invoke GetStdHandle, STD_INPUT_HANDLE
mov consIn, rax
; ������� ��������� �� �������
invoke WriteConsole, consOut, addr str3, len3, addr cWriten, 0
invoke ReadConsole, consIn,addr buf,10,addr str0,0   ;��������� ������ � �������
invoke lstrcmp,addr szPas,addr buf                   ;��������� ����� ��������
.if rax==0
jmp exit2
.else
jmp exit        ;���� ������������ ������
.endif
exit2: mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 � c � ��������� real8
vmovsd xmm2,mas2[8]    ; xmm2 � d
vmovsd xmm3,mas2[16]   ; xmm3 � e
vmulsd xmm3,xmm2,xmm3  ; d*e
vsqrtsd xmm3,xmm3,xmm3 ; sqrt(de)
vmulsd xmm1,xmm1,xmm2  ; c*d
vaddsd xmm3,xmm3,xmm1  ; sqrt(de) + c*d
b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 � a
;vcvttsd2si eax,xmm0   ; ��������������� 64-���������� � 32-��������� �����
vaddsd xmm4,xmm3,xmm0 ; sqrt(de) + c*d + a
vcvttsd2si eax,xmm4   ; ��������������� 64-���������� � 32-��������� �����
movsxd r15,eax        ; ���������� ����������� �� 64-�
mov [rdx],eax         ; ���������� ����������
add rbx,8             ; �������� ��� ������� arr1 (��� ����� �)
add rdx,8             ; �������� ��� ������� �����������
dec rcx
jnz b1 ; ������ �� ���������� ����� b1 (������)

invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16],res[24], res[32] 
mov params.cbSize,SIZEOF MSGBOXPARAMSA ; ������ ���������
 mov params.hwndOwner,0 ; ���������� ���� ���������
 invoke GetModuleHandle,0 ; ��������� ����������� ���������
 mov params.hInstance,rax ; ���������� ����������� ���������
 lea rax, buf1 ; ����� ���������
 mov params.lpszText,rax
 lea rax,tit1 ;Caption ; ����� �������� ����
 mov params.lpszCaption,rax
 mov params.dwStyle,MB_USERICON ; ����� ����
 mov params.lpszIcon,IDI_ICON ; ������ ������
 mov params.dwContextHelpId,0 ; �������� �������
 mov params.lpfnMsgBoxCallback,0 ;
 mov params.dwLanguageId,LANG_NEUTRAL ; ���� ���������
 lea rcx,params
 invoke MessageBoxIndirect
exit: invoke RtlExitUserProcess,0
WinMain endp
�nd
