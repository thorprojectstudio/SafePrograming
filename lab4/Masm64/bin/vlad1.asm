include win64a.inc
.data
str3 db "Input password:*********",0ah,0
szPas db "Kovalenko",0
szStr1 db "�� ����� ���������� ������. �����������!",0
szStr2 db "�� ����� ������������ ������.",0
plen dq sizeof szPas
len1 dq sizeof str3
ttl db "������������ ���������� ��������� ����� ������",0
titl db "��������� ���������",0
str0 dq ?
buf dq 5 
consIn dq ?
consOut dq ?
cWriten dq ?
Err1 dq 0
dir db 14 dup(0) ;���������� ��� �������� ���� � ������� ����������
 
mas1 dd 10,33,3,64,-6,  ; ������ ������
7,-80,-6,78,-8,
24,6,-7,-9,-23

len2 equ ($-mas1)/type mas1  ; ����� �������
len3 equ ($-mas1)/18 ; ����������� ���������� ����� � �������
sum1 dd 0 ; ��� ����� ����� ������� �������
sum2 dd 0 ; ��� ����� ����� ������� �������
sum3 dd 0 ; ��� ����� ����� �������� �������
sum4 dd 0 ; ��� ����� ����� ���������� �������
sum5 dd 0 ; ��� ����� ����� ������ �������

buf1 dd 600 dup(0),0 ;

fmt db "�������: ����� ����� ��������� �������� ",0dh,0ah,\
" 10 33 3 64 -6 ",10,\
" 7 -80 -6 78 -8 ",10,\
" 24 6 -7 -9 -23 ",0dh,0ah,\

"����� ������� �������: %d",0dh,0ah,\
"����� ������� �������: %d",0dh,0ah,\
"����� �������� �������: %d",0dh,0ah,\
"����� ���������� �������: %d",0dh,0ah,\
"����� ������ �������: %d",0dh,0ah,\
"���������� ���������: - %s",0dh,0ah

.code
Pas1 proc 
lea rsi,szPas  ;����� ������� �������� ������
lea rdi,buf ;����� ������� �������� ������
mov rcx,plen
repe cmpsb ;�������� ����������� len ���
jz m2       ;
inc Err1 ; ������� ������������
m2:
ret
Pas1 endp

WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 � �������
mov rbp,rsp

; �������� ����������� ����� ������
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consOut, rax
; �������� ����������� ����� �����
invoke GetStdHandle, STD_INPUT_HANDLE
mov consIn, rax
; ������� ��������� �� �������
invoke WriteConsole, consOut, addr str3, len1, addr cWriten, 0
invoke ReadConsole, consIn,addr buf,9,addr str0,0   ;��������� ������ � �������
invoke Pas1
.if (Err1==0);
invoke MessageBox,0,addr szStr1,addr ttl,MB_ICONINFORMATION
.else
invoke MessageBox,0,addr szStr2,addr ttl,MB_ICONERROR
jmp exx        ;���� ������������ ������
.endif

mov ecx,len3    ;���������� ����� � ����� ������
lea rsi,mas1    ;����� ������ �������

mov eax,[rsi]   ;�������� �����
mov sum1,eax
add rsi,20      ;��������� �� ��������� ������
mov eax,[rsi]   ;��������� ����� � ������� eax
add sum1,eax    ;���������� �������� ������� �������
add rsi,20      ;��������� �� ��������� ������
mov eax,[rsi]   ;��������� ����� � ������� eax
add sum1,eax    ;���������� �������� ������� �������

lea rsi,mas1   
add rsi,4      
mov eax,[rsi]  
mov sum2,eax
add rsi,20      
mov eax,[rsi]  
add sum2,eax
add rsi,20      
mov eax,[rsi]  
add sum2,eax

lea rsi,mas1   
add rsi,8      
mov eax,[rsi]  
mov sum3,eax
add rsi,20      
mov eax,[rsi]  
add sum3,eax
add rsi,20      
mov eax,[rsi]  
add sum3,eax

lea rsi,mas1   
add rsi,12      
mov eax,[rsi]  
mov sum4,eax
add rsi,20      
mov eax,[rsi]  
add sum4,eax
add rsi,20      
mov eax,[rsi]  
add sum4,eax

lea rsi,mas1   
add rsi,16      
mov eax,[rsi]  
mov sum5,eax
add rsi,20      
mov eax,[rsi]  
add sum5,eax
add rsi,20      
mov eax,[rsi]  
add sum5,eax


invoke GetCurrentDirectory,255,ADDR dir; ��������� ����������
invoke wsprintf, ADDR buf1, ADDR fmt,sum1,sum2,sum3,sum4,sum5,ADDR dir
invoke MessageBox,0,addr buf1,addr titl,MB_ICONEXCLAMATION
exx:
invoke RtlExitUserProcess,0 ;ExitProcess,0
WinMain endp
end