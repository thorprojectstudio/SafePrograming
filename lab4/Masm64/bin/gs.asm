include win64a.inc
.data
mem1 dq 111 ; ����� � ������ ��� ������
st1 db " MessageBoxTimeout ",0 ; �������� ����
st2 dq ?,0 ; ����� ������ ���������
ifmt db "mem1 = %d", 0dh,0ah, ; ������� ����������� ������� mem1
"� = %d",0dh,0ah,"y = %d", 0dh,0ah, ; ������� �������������� �������� � � y
"����� ���������: ��� ���, ���, ���. ���",0 ; ��������� ���������
.code
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 - �������
mov rbp,rsp
db 49h,0C7h,0C3h,04Dh,01,00,00
;mov r11,333
mov r12,7777
invoke wsprintf, ADDR st2,ADDR ifmt,mem1,r11,r12
invoke MessageBoxTimeout,0,addr st2,addr st1,MB_OK,0,5000

WinMain endp
end