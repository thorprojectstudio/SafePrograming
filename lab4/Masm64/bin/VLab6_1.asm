; masm64. Числа а є{a1,a2,a3,a4} заданы массивом
; и имеют размерность Real8. Вычислить уравнение ab + c/d - sqrt(e)
include win64a.inc  ;  подключаемые библиотеки

_WQ segment READ WRITE EXECUTE alias("KVS")
; уравнение ab + c/d - sqrt(e)
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

mov rcx,225h; Цикл, для шифрования/дешифрования 81 байта
mov rax,$+15h ; Запись в rax адрес первого байта для шифра
mov bl,1Ch ; Запись ключа в rbx
lp:
 xor byte ptr [rax],bl ; Производим операцию xor с ключем
 not bl; Меняем ключ (операция делает инверсию ключа)
 inc rax ; Переходим на следующий байт
loop lp

mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 — b — переслать real8
vmovsd xmm2,mas2[8]    ; xmm2 — c
vmovsd xmm3,mas2[16]   ; xmm3 — d
vmovsd xmm4,mas2[24]   ; xmm4 — e
vdivsd xmm3,xmm2,xmm3  ; d/a
vsqrtsd xmm4,xmm4,xmm4 ; sqrt(e)
vsubsd xmm4,xmm3,xmm4  ; d/a - sqrt(e)
b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 — a
vmulsd xmm5,xmm0,xmm1 ; a*b
vcvttsd2si eax,xmm5   ; конвертирование 64-разрядного в 32-разрядное целое
vaddsd xmm5,xmm5,xmm4 ; ab + c/d - sqrt(e)
vcvttsd2si eax,xmm5   ; конвертирование 64-разрядного в 32-разрядное целое
movsxd r15,eax        ; расширение разрядности до 64-х
mov [rdx],eax         ; сохранение результата
add rbx,8             ; смещение для массива arr1 (для чисел А)
add rdx,8             ; смещение для массива результатов
dec rcx
jnz b1 ; ссылка на предыдущую метку b1 (наверх)
invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16],res[24]
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
invoke RtlExitUserProcess,0 ; ExitProcess,0
WinMain endp

mas1 real8 1.,2.,3.,4. ; массив чисел а
len1 equ ($-mas1)/type mas1
mas2 real8 2.,20.,5.,25.         ; b, c, d, e
tit1 db 'masm64. AVX. Результат вычисления уравнения ab + c/d - sqrt(e).',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; буфер вывода сообщения

ifmt db 'masm64.  Массив ai = 1., 2., 3., 4.',10,
9,'Числа: b, c, d, e  := 2., 20., 5., 25.',10,
'Результаты вычисления: %d ,%d ,%d ,%d ',10,10,
'Автор: Коваленко В.С.,КИТ-16A, НТУ ХПИ',10,0


_WQ ends
end