include win64a.inc
.data 


.code 
WinMain proc
sub rsp,28h; c���: 28h=32d+8; 8 - �������
mov rbp,rsp	



invoke ExitProcess,0
WinMain endp
end	