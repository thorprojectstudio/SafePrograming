include win64a.inc
.data ;
mas1 db 'The grass is always greener   on the other side of  the fence' ; ������ ������ � ��������� ���� ASCII
len1 equ $-mas1 ; ����������� ���������� ������ � ������� mas1
titl db " ���������",0 ; ����� ����
buf db ?,0 ; ����� ������ ���������
ifmt db "���-�� ����, ��������� ����� ��� �� ������� ���� %d",10,10,
"����� ���������: ������ �.�., ���. ���, ��� ���",0
.code
WinMain proc
sub rsp,28h; ������������ ����� 28h=40d=32d+8; 8 - �������
mov rbp,rsp

xor r11, r11
lea rdi,mas1 ; �������� ������ ������� mas1
mov rax, ' ' ; �������� ������� �f�
mov rcx,len1 ; ���������� � ������� max �������� ����

c3:
cld ; ����������� - �����
scasb
jz m2

add r10, 1
cmp r10, 5

jnz m3

add r11, 1
jmp m3

m2:
xor r10, r10
m3:
loop c3 

invoke wsprintf,ADDR buf,ADDR ifmt,r11 ;
invoke MessageBox,0,addr buf,addr titl,MB_OK
ret
WinMain endp
end
