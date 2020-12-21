; ������������ �������� � ������� ���-������ ��� ��������� ����� �����.
; ���� ������ ����� ������ 55, �� ��������� ��������
; a � c/b � dc  (-4,83), �� a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; ����� � ��������� �������� a � c/b   (2,43)

include win64a.inc

fpuDiv macro _a,_c,_b ; ������ � ������ fpuDiv
fld _c
fdiv _b
fld _a
fsubr
endm ;; ��������� �������

.data

_a REAL4 2.8
_b REAL4 8.05
_c REAL4 2.2
_d REAL4 3.3

arr1 dw 1,25,3,4          ; ������ ����� arr1 �������� � �����
len1 equ ($-arr1)/type arr1  ; ���������� ����� �������
arr2 dw 5,31,7,5        ; ������ ����� arr2 �������� � �����
len2 equ ($-arr2)/type arr2    ; ���������� ����� �������
arr1_2 dw len1 dup(0) ; ������ ������ ��� ����� ��������

tit1 db "masm64. O������� MMX-FPU",0  ; �������� ������
st2 dd 0             ; ����� ����� ��� ������ ���������
buf1 db 0,0
buf2 dq 1 dup(0);
ifmt db "  ������������ �������� � ������� ���-������ ��� ��������� ����� �����.",10,
"���� ������ ����� ������ 55, �� ��������� ��������:",10,
"a � c/b � dc  (-4,83), ��� a = 2,7; b = 8,05; c = 2,2; d = 3,3;",10,
"����� � ��������� �������� a � c/b   (2,43)",10,10,"����� =  %d ",10,10,
"�����: ��������� �.�., ���. ���, ��� ���",10,
9,"����:  http://blogs.kpi.kharkov.ua/v2/asm/",0


.code
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 32d x 8 = 256/16=16 ����;8 � �������
mov rbp,rsp
movq MM1,QWORD PTR arr1  ; �������� ������� ����� arr1
movq MM2,QWORD PTR arr2 ; �������� ������� ����� arr2
paddw MM1,MM2     ; ������������ ����������� ��������
movq QWORD PTR arr1_2,MM1       ; ���������� ����������
pextrw eax,MM1,1   ; ����������� ������� ����� �������� ����� � eax
emms               ; ��������� ���-�������
cmp eax,55
jg @2 ; if >

@1:   fpuDiv [_a],[_c],[_b] 
jmp m1

@2:   fpuDiv [_a],[_c],[_b] 
fld _d
fmul _c
fsub
m1: fisttp st2 ; ���������� ������ �����  �����
invoke wsprintf,ADDR buf1,ADDR ifmt,st2  
invoke MessageBox, NULL, addr buf1, addr ifmt, MB_ICONINFORMATION
invoke ExitProcess,0

WinMain endp
end