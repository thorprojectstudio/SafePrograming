; ��������� ab + c/d
.DATA	 ; ��������� ������ �������� ������
a1 dq 1 ; �������������� ������ ��� ����������
b1 dq 2 ; �������������� ������ ��� ����������
c1 dq 7
d1 dq 3
.CODE	     ; 
WinMain proc
mov rax,a1
mul b1
mov r10,rax

mov rax,c1
div d1
add r10,rax

WinMain endp
end