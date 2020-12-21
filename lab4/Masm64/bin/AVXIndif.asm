include win64a.inc  ;  ������������ ����������
.data
titl db "masm64.�������� ��������������� �� ��������� ������ AVX",0
szInf db "������� AVX ��������������!!!",0 ;
inf db "������� AVX ���������������� �� ��������������",0;
tit2 db "masm64.�������� ��������������� �� ��������� ������ AVX2",0
szInf2 db "������� AVX2 ��������������!!!",0 ;
inf2 db "������� AVX2 ���������������� �� ��������������",0;

.code              
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
jmp exit
exit2:
invoke MessageBox,0,addr szInf2,addr tit2,MB_ICONINFORMATION

exit: invoke RtlExitUserProcess,0
WinMain endp
end
