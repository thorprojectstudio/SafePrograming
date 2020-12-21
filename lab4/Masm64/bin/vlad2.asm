;решение уравнения 64d/ca
include win64a.inc
.data           ; директива начала сегмента данных
const1 dq 64    ; объявление константы 64
a1 dq 2         ; резервирование в памяти 8 байтов для переменной a
c1 dq 4         ; резервирование в памяти 8 байтов для переменной c
d1 dq 512       ; резервирование в памяти 8 байтов для переменной d

titl db 'Вывод через функцию MessageBox',0; название упрощенного окна
st1 dq ?,0  ; буфер выведения сообщения.
ifmt  db 'Вывод чисел с памяти через MessageBox:',10,9,'64d/ca',10,
'a = %d',10,'c = %d',10,'d = %d',10,'res = %d',10,10,
'Время выполнения  = %d тиков',10,  ;
'Автор программы:    ',0 ;

.code           ; директива начала сегментa команд
WinMain proc
sub rsp,28h     ; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp
rdtsc           ; функция читающая счётчик TSC (Time Stamp Counter) 
xchg rdi,rax    ; обмен значениями регистров

mov rax,c1      ; заносим значение с1 в регистр rax
mul a1          ; умножаем на a1
mov r9,rax      ; заносим результат в регистр r9
mov rax,d1      ; заносим значение d1 в регистр rax
mul const1      ; умножаем на 64
xor rdx,rdx     ; подготовка к делению
div r9          ; 16d/ca
mov r10,rax     ; заносим результат в регистр r10

rdtsc          ; получение числа тактов
sub rax,rdi    ; вычитание из последнего числа тактов предыдущего числа
invoke wsprintf,ADDR st1,ADDR ifmt,a1,c1,d1,r10,rax
invoke MessageBox,0,addr st1,addr titl,MB_ICONINFORMATION;
invoke RtlExitUserProcess,0  ; возвращение упр. ОС и освобожд. ресурсов
WinMain endp
end
