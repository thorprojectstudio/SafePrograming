OPTION DOTNAME
	
option casemap:none
include temphls.inc
include win64.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none

.data
MsgCaption      db 'Win64 Iczelion''s lesson #2: MessageBox',0
MsgBoxText      db 'Win64 Assembly is Great!',0
.code
WinMain proc 
	sub rsp,28h
      invoke MessageBox, NULL, &MsgBoxText, &MsgCaption, MB_OK
      invoke ExitProcess,NULL
WinMain endp
end