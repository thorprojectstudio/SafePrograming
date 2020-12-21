; masm64. Числа а є{a1,a2,a3} заданы массивом
; и имеют размерность Real8. Вычислить уравнение b * sqrt(d) + 8a
include win64a.inc  ;  подключаемые библиотеки
.data
fileN db "AVXIndif.exe",0

mas1 real8 1.,2.,3. ; массив чисел а
len1 equ ($-mas1)/type mas1
mas2 real8 2.,25.,8.         ; b, d, 8
tit1 db 'masm64. AVX. Результат вычисления уравнения b * sqrt(d) + 8a.',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; буфер вывода сообщения

ifmt db 'masm64.  Массив ai = 1., 2., 3.',10,
9,'Числа: b, d  := 2., 25.',10,
'Результаты вычисления: %d ,%d ,%d',10,10,
'Автор: Коваленко В.С.,КИТ-16A, НТУ ХПИ',10,0

ifmt2 db 'Программу трассируют',10,
9,'Числo: d := 25.',10,
'sqrt(d) := %d',10,0

titltras1 db "Исследование трассировки",0
szTest db "Программу НЕ трассируют",0
szTest2 db "Программу трассируют",0
Time1 dq ? ;
Time2 dq ? ;
Clas dq ?;

.code               ; уравнение b * sqrt(d) + 8a
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

mov rcx,len1
lea rdx,res
lea rbx,mas1

invoke GetCurrentThreadId;
;invoke OpenThread,THREAD_QUERY_INFORMATION,0,rax
invoke NtQueryInformationThread,rax,addr Clas,addr Time1,32 ;

invoke GetCurrentThreadId;
;invoke OpenThread,THREAD_QUERY_INFORMATION,0,rax
invoke NtQueryInformationThread,rax,addr Clas,addr Time2,32 ;

mov rax, Time1 ;
mov rbx, Time2 ;
sub rax, rbx
cmp rax, 1000 ; сравнение с 1000 тактов
ja debug1 ; если >1000
invoke MessageBox,0,addr szTest,addr titltras1,MB_ICONINFORMATION
jmp run
debug1:
vmovsd xmm2,mas2[8]    ; xmm2 — d
vsqrtsd xmm2,xmm2,xmm2 ; sqrt(d)
vcvttsd2si eax,xmm2   ; конвертирование 64-разрядного в 32-разрядное целое
movsxd r15,eax        ; расширение разрядности до 64-х
invoke wsprintf,addr buf1,addr ifmt2,r15
invoke MessageBox,0,addr buf1,0,MB_OK
jmp exit

run:
; проверка на поддержку AVX команд
invoke WinExec,addr fileN, SW_SHOW

mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 — b — переслать real8
vmovsd xmm2,mas2[8]    ; xmm2 — d
vmovsd xmm3,mas2[16]   ; xmm3 — 8
vsqrtsd xmm2,xmm2,xmm2 ; sqrt(d)
vmulsd xmm1,xmm1,xmm2  ; b* sqrt(d)

b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 — a
vmulsd xmm5,xmm0,xmm3 ; a*8
vcvttsd2si eax,xmm5   ; конвертирование 64-разрядного в 32-разрядное целое
vaddsd xmm5,xmm5,xmm1 ; b * sqrt(d) + 8a
vcvttsd2si eax,xmm5   ; конвертирование 64-разрядного в 32-разрядное целое
movsxd r15,eax        ; расширение разрядности до 64-х
mov [rdx],eax         ; сохранение результата
add rbx,8             ; смещение для массива arr1 (для чисел А)
add rdx,8             ; смещение для массива результатов
dec rcx
jnz b1 ; ссылка на предыдущую метку b1 (наверх)
invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16]
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
exit: invoke RtlExitUserProcess,0
WinMain endp
end
