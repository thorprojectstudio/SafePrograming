include win64a.inc
.data
str3 db "Input password:*********",0ah,0
szPas db "Kovalenko",0
szStr1 db "Вы ввели корректный пароль. Поздравляем!",0
szStr2 db "Вы ввели неправильный пароль.",0
plen dq sizeof szPas
len1 dq sizeof str3
ttl db "Элементарная консольная программа ввода пароля",0
titl db "Результат программы",0
str0 dq ?
buf dq 5 
consIn dq ?
consOut dq ?
cWriten dq ?
Err1 dq 0
dir db 14 dup(0) ;переменная для хранения пути к текущей директории
 
mas1 dd 10,33,3,64,-6,  ; массив данных
7,-80,-6,78,-8,
24,6,-7,-9,-23

len2 equ ($-mas1)/type mas1  ; длина массива
len3 equ ($-mas1)/18 ; определение количества чисел в строках
sum1 dd 0 ; для суммы чисел первого столбца
sum2 dd 0 ; для суммы чисел второго столбца
sum3 dd 0 ; для суммы чисел третьего столбца
sum4 dd 0 ; для суммы чисел четвертого столбца
sum5 dd 0 ; для суммы чисел пятого столбца

buf1 dd 600 dup(0),0 ;

fmt db "Условие: найти сумму элементов столбцов ",0dh,0ah,\
" 10 33 3 64 -6 ",10,\
" 7 -80 -6 78 -8 ",10,\
" 24 6 -7 -9 -23 ",0dh,0ah,\

"Сумма первого столбца: %d",0dh,0ah,\
"Сумма второго столбца: %d",0dh,0ah,\
"Сумма третьего столбца: %d",0dh,0ah,\
"Сумма четвертого столбца: %d",0dh,0ah,\
"Сумма пятого столбца: %d",0dh,0ah,\
"Директория программы: - %s",0dh,0ah

.code
Pas1 proc 
lea rsi,szPas  ;адрес первого элемента строки
lea rdi,buf ;адрес второго элемента строки
mov rcx,plen
repe cmpsb ;побайтно проверяется len раз
jz m2       ;
inc Err1 ; счетчик несовпадений
m2:
ret
Pas1 endp

WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

; Получаем стандартный поток вывода
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov consOut, rax
; Получаем стандартный поток ввода
invoke GetStdHandle, STD_INPUT_HANDLE
mov consIn, rax
; Выводим сообщение на консоль
invoke WriteConsole, consOut, addr str3, len1, addr cWriten, 0
invoke ReadConsole, consIn,addr buf,9,addr str0,0   ;считываем данные с консоли
invoke Pas1
.if (Err1==0);
invoke MessageBox,0,addr szStr1,addr ttl,MB_ICONINFORMATION
.else
invoke MessageBox,0,addr szStr2,addr ttl,MB_ICONERROR
jmp exx        ;если неправильный пароль
.endif

mov ecx,len3    ;количество чисел в одной строке
lea rsi,mas1    ;адрес начала массива

mov eax,[rsi]   ;загрузка числа
mov sum1,eax
add rsi,20      ;переходим на следующую строку
mov eax,[rsi]   ;загружаем число в регистр eax
add sum1,eax    ;складываем элементы первого столбца
add rsi,20      ;переходим на следующую строку
mov eax,[rsi]   ;загружаем число в регистр eax
add sum1,eax    ;складываем элементы первого столбца

lea rsi,mas1   
add rsi,4      
mov eax,[rsi]  
mov sum2,eax
add rsi,20      
mov eax,[rsi]  
add sum2,eax
add rsi,20      
mov eax,[rsi]  
add sum2,eax

lea rsi,mas1   
add rsi,8      
mov eax,[rsi]  
mov sum3,eax
add rsi,20      
mov eax,[rsi]  
add sum3,eax
add rsi,20      
mov eax,[rsi]  
add sum3,eax

lea rsi,mas1   
add rsi,12      
mov eax,[rsi]  
mov sum4,eax
add rsi,20      
mov eax,[rsi]  
add sum4,eax
add rsi,20      
mov eax,[rsi]  
add sum4,eax

lea rsi,mas1   
add rsi,16      
mov eax,[rsi]  
mov sum5,eax
add rsi,20      
mov eax,[rsi]  
add sum5,eax
add rsi,20      
mov eax,[rsi]  
add sum5,eax


invoke GetCurrentDirectory,255,ADDR dir; получение директории
invoke wsprintf, ADDR buf1, ADDR fmt,sum1,sum2,sum3,sum4,sum5,ADDR dir
invoke MessageBox,0,addr buf1,addr titl,MB_ICONEXCLAMATION
exx:
invoke RtlExitUserProcess,0 ;ExitProcess,0
WinMain endp
end