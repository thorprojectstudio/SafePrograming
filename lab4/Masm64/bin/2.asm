;include win64a.inc
OPTION DOTNAME ; ���. � ���������� ������� ����������
include temphls.inc
include win64.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
OPTION PROLOGUE:none
OPTION EPILOGUE:none

.DATA ; ��������� ������ �������� ������
X DW 5 ; �������������� � ������ 2-� ������ ��� ���������� �
Y DW 3 ; �������������� � ������ 2-� ������ ��� ���������� Y
Z DW ? ; �������������� � ������ 2-� ������ ��� ���������� Z
titl db "masm64. ����� ����� ������� MessageBox",0; �������� ����������� ����
st1 dw ?,0 ; ����� ��������� ���������. dw ��� ��������� �����
ifmt db "����� ����� � ������ ����� MessageBox:", 0dh,0ah,
"� = 12", 0dh,0ah, 'c = 97', 0dh,0ah,
"a - c = -%d", 0dh,0ah,0ah, ; ������� ����������� �������
"����� ���������: , ���26B",0 


.CODE ; ��������� ������ �������� ������
WinMain proc
sub rsp,28h; ������������ ����� 28h=40d=32d+8; 8 - �������
mov rbp,rsp

MOV AX,X ; �������� �������� �
ADD AX,Y ; �������� ��������� � � Y
MOV Z,AX ; ���������� ���������� � ������ � ������ � ������ Z
invoke wsprintf,ADDR st1,ADDR ifmt,Z
invoke MessageBox,0,addr st1,addr titl,MB_ICONINFORMATION
invoke ExitProcess, 0 ;
WinMain endp
end