; masm64. Числа а є{a1,a2,a3,a4} заданы массивом
; и имеют размерность Real8. Вычислить уравнение  sqrt(a) * b + c/d/e

include win64a.inc ; подключаемые библиотеки
IDI_ICON EQU 1001 ; идентификатор иконки
MSGBOXPARAMSA STRUCT
 cbSize DWORD ?,?
 hwndOwner QWORD ?
 hInstance QWORD ?
 lpszText QWORD ?
 lpszCaption QWORD ?
 dwStyle DWORD ?,?
 lpszIcon QWORD ?
 dwContextHelpId QWORD ?
 lpfnMsgBoxCallback QWORD ?
 dwLanguageId DWORD ?,?
MSGBOXPARAMSA ENDS



.data
 params MSGBOXPARAMSA <>
 fileN db "AVXIndif.exe",0

str3 db "Input password:**********",0ah,0
szPas db "Kovalenko",0
plen dq sizeof szPas
len3 dq sizeof str3
str0 dq ?
buf dq ? 
consIn dq ?
consOut dq ?
cWriten dq ?

mas1 real8 4.,9.,16.,25.,36. ; массив чисел а
len1 equ ($-mas1)/type mas1
mas2 real8 1., 24., 2., 3.         ; b, c, d, e
tit1 db 'masm64. AVX. Результат вычисления уравнения sqrt(a) * b + c/d/e',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; буфер вывода сообщения

ifmt db 'masm64.  Массив ai = 4., 9., 16., 25., 36.',10,
9,'Числа: b, c, d, e  := 1., 24., 2., 3.',10,
'Результаты вычисления: %d ,%d ,%d ,%d, %d ',10,10,
'Автор: Коваленко В.С.,КИТ-16А, НТУ ХПI',10,0

.code               ; уравнение sqrt(a) * b + c/d/e
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

mov ax,37EBh
jmp $ - 2 ; пропуск 2 байтов EB 

mov ax,05EBh
jmp $ - 2  ; пропуск 2 байтов EB 05 и остановка на EB
; EB 05 – это jmp на 5 байтов вперед с учетом своих 2-х байтов
dec r9  ; пропускаем, 3 байта: 49:FFC9
inc r10  ; выполняем с этой команды
mov r8,1
mov eax,06EB0000h
jmp $ - 2  ; пропуск 2 байтов 06 и EB и остановка на EB
; EB 06 – это jmp на 6 байтов вперед с учетом своих 2-х байтов
dec cl  ; пропускаем, 2 байта: FE C9
dec al      ; пропускаем, 2 байта: FE C8
dec dl   ; выполняем с этой команды
nop
mov rax,09EB000000000000h
jmp $ - 2  ; пропуск 2 байтов EB 09 и остановка на EB
; EB 09 – это jmp на 9 байтов вперед с учетом своих 2-х байтов
mov r15,1  ; пропускаем, 7 байтов: 49:C7C7 01000000
nop  ; выполняем с этой команды
mov ax,37EBh
jmp $ - 2 ; пропуск 2 байтов EB 

mov ax,05EBh
jmp $ - 2  ; пропуск 2 байтов EB 05 и остановка на EB
; EB 05 – это jmp на 5 байтов вперед с учетом своих 2-х байтов
dec r9  ; пропускаем, 3 байта: 49:FFC9
inc r10  ; выполняем с этой команды
mov r8,1
mov eax,06EB0000h
jmp $ - 2  ; пропуск 2 байтов 06 и EB и остановка на EB
; EB 06 – это jmp на 6 байтов вперед с учетом своих 2-х байтов
dec cl  ; пропускаем, 2 байта: FE C9
dec al      ; пропускаем, 2 байта: FE C8
dec dl   ; выполняем с этой команды
nop
mov rax,09EB000000000000h
jmp $ - 2  ; пропуск 2 байтов EB 09 и остановка на EB
; EB 09 – это jmp на 9 байтов вперед с учетом своих 2-х байтов
mov r15,1  ; пропускаем, 7 байтов: 49:C7C7 01000000
nop  ; выполняем с этой команды
mov ax,37EBh
jmp $ - 2 ; пропуск 2 байтов EB 

mov ax,05EBh
jmp $ - 2  ; пропуск 2 байтов EB 05 и остановка на EB
; EB 05 – это jmp на 5 байтов вперед с учетом своих 2-х байтов
dec r9  ; пропускаем, 3 байта: 49:FFC9
inc r10  ; выполняем с этой команды
mov r8,1
mov eax,06EB0000h
jmp $ - 2  ; пропуск 2 байтов 06 и EB и остановка на EB
; EB 06 – это jmp на 6 байтов вперед с учетом своих 2-х байтов
dec cl  ; пропускаем, 2 байта: FE C9
dec al      ; пропускаем, 2 байта: FE C8
dec dl   ; выполняем с этой команды
nop
mov rax,09EB000000000000h
jmp $ - 2  ; пропуск 2 байтов EB 09 и остановка на EB
; EB 09 – это jmp на 9 байтов вперед с учетом своих 2-х байтов
mov r15,1  ; пропускаем, 7 байтов: 49:C7C7 01000000
nop  ; выполняем с этой команды
mov ax,37EBh
jmp $ - 2 ; пропуск 2 байтов EB 

mov ax,05EBh
jmp $ - 2  ; пропуск 2 байтов EB 05 и остановка на EB
; EB 05 – это jmp на 5 байтов вперед с учетом своих 2-х байтов
dec r9  ; пропускаем, 3 байта: 49:FFC9
inc r10  ; выполняем с этой команды
mov r8,1
mov eax,06EB0000h
jmp $ - 2  ; пропуск 2 байтов 06 и EB и остановка на EB
; EB 06 – это jmp на 6 байтов вперед с учетом своих 2-х байтов
dec cl  ; пропускаем, 2 байта: FE C9
dec al      ; пропускаем, 2 байта: FE C8
dec dl   ; выполняем с этой команды
nop
mov rax,09EB000000000000h
jmp $ - 2  ; пропуск 2 байтов EB 09 и остановка на EB
; EB 09 – это jmp на 9 байтов вперед с учетом своих 2-х байтов
mov r15,1  ; пропускаем, 7 байтов: 49:C7C7 01000000
nop  ; выполняем с этой команды


invoke WinExec,addr fileN, SW_SHOW

; Получаем стандартный поток вывода
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consOut, rax
; Получаем стандартный поток ввода
invoke GetStdHandle, STD_INPUT_HANDLE
mov consIn, rax
; Выводим сообщение на консоль
invoke WriteConsole, consOut, addr str3, len3, addr cWriten, 0
invoke ReadConsole, consIn,addr buf,9,addr str0,0   ;считываем данные с консоли
invoke lstrcmp,addr szPas,addr buf                   ;сравнение строк символов
.if rax==0
jmp exit2
.else
jmp exit        ;если неправильный пароль
.endif
exit2: mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 — b — переслать real8
vmovsd xmm2,mas2[8]    ; xmm2 — c
vmovsd xmm3,mas2[16]   ; xmm3 — d
vmovsd xmm4,mas2[24]   ; xmm4 — e
vdivsd xmm3,xmm2,xmm3  ; c/d
vdivsd xmm3,xmm3,xmm4  ; c/d/e

b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 — a
vsqrtsd xmm0,xmm0,xmm0 ; sqrt(a)
vmulsd xmm0,xmm0,xmm1  ; sqrt(a)*b
vaddsd xmm4,xmm3,xmm0  ; sqrt(a) * b + c/d/e
vcvttsd2si eax,xmm4    ; конвертирование 64-разрядного в 32-разрядное целое
movsxd r15,eax         ; расширение разрядности до 64-х
mov [rdx],eax          ; сохранение результата
add rbx,8              ; смещение для массива arr1 (для чисел А)
add rdx,8              ; смещение для массива результатов
dec rcx 
jnz b1 ; ссылка на предыдущую метку b1 (наверх)

invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16],res[24], res[32] 
mov params.cbSize,SIZEOF MSGBOXPARAMSA ; размер структуры
 mov params.hwndOwner,0 ; дескриптор окна владельца
 invoke GetModuleHandle,0 ; получение дескриптора программы
 mov params.hInstance,rax ; сохранение дескриптора программы
 lea rax, buf1 ; адрес сообщения
 mov params.lpszText,rax
 lea rax,tit1 ;Caption ; адрес заглавия окна
 mov params.lpszCaption,rax
 mov params.dwStyle,MB_USERICON ; стиль окна
 mov params.lpszIcon,IDI_ICON ; ресурс значка
 mov params.dwContextHelpId,0 ; контекст справки
 mov params.lpfnMsgBoxCallback,0 ;
 mov params.dwLanguageId,LANG_NEUTRAL ; язык сообщения
 lea rcx,params
 invoke MessageBoxIndirect
exit: invoke RtlExitUserProcess,0
WinMain endp
end
