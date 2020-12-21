include win64a.inc
.data 


.code 
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 - возврат
mov rbp,rsp	



invoke ExitProcess,0
WinMain endp
end	