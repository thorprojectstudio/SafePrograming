;������� ��������� 64d/ca
include win64a.inc
.data           ; ��������� ������ �������� ������
const1 dq 64    ; ���������� ��������� 64
a1 dq 2         ; �������������� � ������ 8 ������ ��� ���������� a
c1 dq 4         ; �������������� � ������ 8 ������ ��� ���������� c
d1 dq 512       ; �������������� � ������ 8 ������ ��� ���������� d

titl db '����� ����� ������� MessageBox',0; �������� ����������� ����
st1 dq ?,0  ; ����� ��������� ���������.
ifmt  db '����� ����� � ������ ����� MessageBox:',10,9,'64d/ca',10,
'a = %d',10,'c = %d',10,'d = %d',10,'res = %d',10,10,
'����� ����������  = %d �����',10,  ;
'����� ���������:    ',0 ;

.code           ; ��������� ������ �������a ������
WinMain proc
sub rsp,28h     ; c���: 28h=32d+8; 8 � �������
mov rbp,rsp
rdtsc           ; ������� �������� ������� TSC (Time Stamp Counter) 
xchg rdi,rax    ; ����� ���������� ���������

mov rax,c1      ; ������� �������� �1 � ������� rax
mul a1          ; �������� �� a1
mov r9,rax      ; ������� ��������� � ������� r9
mov rax,d1      ; ������� �������� d1 � ������� rax
mul const1      ; �������� �� 64
xor rdx,rdx     ; ���������� � �������
div r9          ; 16d/ca
mov r10,rax     ; ������� ��������� � ������� r10

rdtsc          ; ��������� ����� ������
sub rax,rdi    ; ��������� �� ���������� ����� ������ ����������� �����
invoke wsprintf,ADDR st1,ADDR ifmt,a1,c1,d1,r10,rax
invoke MessageBox,0,addr st1,addr titl,MB_ICONINFORMATION;
invoke RtlExitUserProcess,0  ; ����������� ���. �� � ��������. ��������
WinMain endp
end
