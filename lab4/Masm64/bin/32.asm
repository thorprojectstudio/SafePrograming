.686p
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc ;
include \masm32\macros\macros.asm
uselib user32,kernel32,masm32
.data
WinMain PROTO :DWORD,:DWORD,:DWORD, :DWORD
WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
TopXY PROTO :DWORD,:DWORD
RegisterWinClass PROTO :DWORD,:DWORD,:DWORD, :DWORD, :DWORD
Main PROTO
.data?
hInstance dd ?
CommandLine dd ?
hIcon dd ?
hCursor dd ?
sWid dd ?
sHgt dd ?
hWnd dd ?
.code
start:
mov hInstance, FUNC(GetModuleHandle, NULL)
mov CommandLine, FUNC(GetCommandLine)
mov hIcon, FUNC(LoadIcon,NULL,IDI_ASTERISK)
mov hCursor, FUNC(LoadCursor,NULL,IDC_ARROW)
mov sWid, FUNC(GetSystemMetrics,SM_CXSCREEN)
mov sHgt, FUNC(GetSystemMetrics,SM_CYSCREEN)
call Main
invoke ExitProcess,eax
Main proc
LOCAL Wwd:DWORD,Wht:DWORD,Wtx:DWORD,Wty:DWORD
LOCAL msg:MSG
STRING szClassName,"Timer Demo"
invoke RegisterWinClass,ADDR WndProc,ADDR szClassName, hIcon,hCursor,COLOR_BTNFACE+1
mov Wwd, 350
mov Wht, 250
invoke TopXY,Wwd,sWid
mov Wtx, eax
invoke TopXY,Wht,sHgt
mov Wty, eax
invoke CreateWindowEx,WS_EX_LEFT or WS_EX_ACCEPTFILES,
ADDR szClassName, chr$("Отображение местного времени"),
WS_OVERLAPPEDWINDOW,
Wtx,Wty,Wwd,Wht, 0,0,hInstance,0
mov hWnd,eax
invoke ShowWindow,hWnd, SW_SHOWNORMAL; установление состояния показа окна
invoke UpdateWindow,hWnd ; обновление рабочей области окна
.WHILE TRUE ; пока истинное, то
invoke GetMessage, ADDR msg,0,0,0 ; чтение сообщения
or eax, eax ; формирование признаков
jz Quit ; перейти на метку Quit, если сообщений нет
invoke DispatchMessage, ADDR msg ; отправление на обслуживание к WndProc
.ENDW ; окончание цикла обрабатывания сообщений
Quit:
mov eax,msg.wParam
ret
Main endp
RegisterWinClass proc lpWndProc:DWORD, lpClassName:DWORD,
Icon:DWORD, Cursor:DWORD, bColor:DWORD
LOCAL wc:WNDCLASSEX
mov wc.cbSize, sizeof WNDCLASSEX
mov wc.style, CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW
m2m wc.lpfnWndProc, lpWndProc
mov wc.cbClsExtra, NULL
mov wc.cbWndExtra, NULL
m2m wc.hInstance, hInstance
m2m wc.hbrBackground, bColor
mov wc.lpszMenuName, NULL
m2m wc.lpszClassName, lpClassName
m2m wc.hIcon, Icon
m2m wc.hCursor, Cursor
m2m wc.hIconSm, Icon
invoke RegisterClassEx, ADDR wc
ret
RegisterWinClass endp
TopXY proc wDim:DWORD, sDim:DWORD
shr sDim, 1 ; деление screen на 2
shr wDim, 1 ; деление dimension на 2
mov eax, wDim ;
sub sDim, eax ; return sDim
TopXY endp
end start