; masm64. Числа а є{a1,a2,a3,a4} заданы массивом
; и имеют размерность Real8. Вычислить уравнение с * sqrt(de) + d/a
include win64a.inc  ;  подключаемые библиотеки

_MALEX segment READ WRITE EXECUTE alias("MAI")

;1576
;1752/176

; уравнение с * sqrt(de) + d/a
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

mov rcx, 58h; Цикл, для шифрования/дешифрования 81 байта
mov rax,$+1Dh ; Запись в rax адрес первого байта для шифра
mov rbx,0B ; Запись ключа в rbx
lp:
rol word ptr [rax],11
inc rax ; Переходим на следующий байт
inc rax
loop lp


mov rcx,len1
lea rdx,res
lea rbx,mas1

vmovsd xmm1,mas2[0]    ; xmm1 — c — переслать real8
vmovsd xmm2,mas2[8]    ; xmm2 — d
vmovsd xmm3,mas2[16]   ; xmm3 — e
vmulsd xmm3,xmm2,xmm3  ; d*e
vsqrtsd xmm3,xmm3,xmm3 ; sqrt(de)
vmulsd xmm1,xmm1,xmm3  ; c* sqrt(de)
b1:
vmovsd xmm0,qword ptr[rbx] ; xmm0 — a
vdivsd xmm4,xmm2,xmm0 ; d/a
vcvttsd2si eax,xmm4   ; конвертирование 64-разрядного в 32-разрядное целое
vaddsd xmm4,xmm1,xmm4 ; с * sqrt(de) + d/a
vcvttsd2si eax,xmm4   ; конвертирование 64-разрядного в 32-разрядное целое
movsxd r15,eax        ; расширение разрядности до 64-х
mov [rdx],eax         ; сохранение результата
add rbx,8             ; смещение для массива arr1 (для чисел А)
add rdx,8             ; смещение для массива результатов
dec rcx
jnz b1 ; ссылка на предыдущую метку b1 (наверх)
invoke wsprintf,addr buf1,addr ifmt,res,res[8],res[16],res[24]
invoke MessageBox,0,addr buf1,addr tit1,MB_ICONINFORMATION
WinMain endp

mas1 real8 1.,2.,4.,6. ; массив чисел а
len1 equ ($-mas1)/type mas1
mas2 real8 4.,36.,1.         ; c, d, e
tit1 db 'masm64. AVX. Результат вычисления уравнения с * sqrt(de) + d/a.',0
res dq len1 DUP(0),0  ;
buf1 dd len1 DUP(0),0  ; буфер вывода сообщения

ifmt db 'masm64.  Массив ai = 1., 2., 4., 6.',10,
9,'Числа: c, d, e  := 4., 36., 1.',10,
'Результаты вычисления: %d ,%d ,%d ,%d ',10,10,
'Автор: Матюшенко А.,КИТ-16а, НТУ ХПИ',10,0


_MALEX ends
end
