BOOL CheckRemoteDebuggerPresent(
 HANDLE hProcess,
 PBOOL pbDebuggerPresent
) 

NTSTATUS NTAPI NtQueryInformationProcess(
 HANDLE ProcessHandle,
 PROCESSINFOCLASS ProcessInformationClass,
 PVOID ProcessInformation,
 ULONG ProcessInformationLength,
 PULONG ReturnLength
) 

; using kernel32!CheckRemoteDebuggerPresent()
 lea eax,[.bDebuggerPresent]
 push eax ;pbDebuggerPresent
 push 0xffffffff ;hProcess
 call [CheckRemoteDebuggerPresent]
 cmp dword [.bDebuggerPresent],0 

 jne .debugger_found

 ; using ntdll!NtQueryInformationProcess(ProcessDebugPort)
 lea eax,[.dwReturnLen]
 push eax ;ReturnLength
 push 4 ;ProcessInformationLength
 lea eax,[.dwDebugPort]
 push eax ;ProcessInformation
 push ProcessDebugPort ;ProcessInformationClass (7)
 push 0xffffffff ;ProcessHandle
 call [NtQueryInformationProcess]
 cmp dword [.dwDebugPort],0
 jne .debugger_found

var bp_NtQueryInformationProcess

 // set a breakpoint handler
 eob bp_handler_NtQueryInformationProcess

 // set a breakpoint where NtQueryInformationProcess returns
 gpa "NtQueryInformationProcess", "ntdll.dll"
 find $RESULT, #C21400# //retn 14
 mov bp_NtQueryInformationProcess,$RESULT
 bphws bp_NtQueryInformationProcess,"x"
 run

bp_handler_NtQueryInformationProcess:
 //ProcessInformationClass == ProcessDebugPort?
 cmp [esp+8], 7
 jne bp_handler_NtQueryInformationProcess_continue

 //patch ProcessInformation to 0
 mov patch_addr, [esp+c]
 mov [patch_addr], 0
 //clear breakpoint
 bphwc bp_NtQueryInformationProcess

bp_handler_NtQueryInformationProcess_continue:
 run 
