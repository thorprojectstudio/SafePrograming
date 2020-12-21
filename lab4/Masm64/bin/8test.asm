include win64a.inc
.data
titl db "Результат программы",0

mas1 dd 10, 33, 3,64,  6,  ; массив данных
         7, 80, 6,78,  8,
        24,  6, 7, 9, 23

len2 equ ($-mas1)/type mas1  ; длина массива
len3 equ ($-mas1)/5 ; определение количества чисел в строках
sum1 dd 0 ; для суммы чисел первой строки
sum2 dd 0 ; для суммы чисел второй строки
sum3 dd 0 ; для суммы чисел третьей строки
buf1 dd 600 dup(0),0 ;

res dd 0;

stdout dd 0 ;
stdin dd 0 ;
rdn dd 0 ;
wrtn dd 0 ;
msg db "Enter symbol:"
MSIZE equ $ - msg ;
symbol db "1" ;
buff db 0 ;
Msg1 db "Пароль совпал",0
Msg2 db "Пароль не корректен",0
Title1 db "Проверка пароля",0

fmt db "Условие: найти строку с максимальной суммой элементов ",0dh,0ah,\
" 10  33  3 64  6 ",10,\
"  7  80  6 78  8 ",10,\
" 24   6  7  9 23 ",0dh,0ah,\
"Максимальная строка # %d",0dh,0ah

.code
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 8 — возврат
mov rbp,rsp

invoke GetStdHandle,STD_INPUT_HANDLE ; извлекает дескриптор устр. ввода
mov stdin,eax ; сохранение дескриптора ввода
invoke GetStdHandle,STD_OUTPUT_HANDLE ; извлекает дескриптор устр. вывода
mov stdout,eax ; сохранение дескриптора вывода
; записывает символьную строку в экранный буфер консоли
invoke WriteConsole,stdout,offset msg,MSIZE,offset wrtn,0
invoke ReadConsole,stdin,offset buff,1,offset rdn, 0
mov al,byte ptr [buff]
cmp al,symbol
jnz _exit
invoke MessageBox,0,addr Msg1,addr Title1,MB_OK
jmp run
_exit:
invoke MessageBox,0,addr Msg2,addr Title1,MB_OK
jmp exit2
run:
mov ecx,len3    ;количество чисел в одной строке

lea rsi,mas1    ;адрес начала массива
mov eax,[rsi]   ;загрузка числа
mov sum1,eax
add rsi,4       ;переходим на следующую строку
mov eax,[rsi]   ;загружаем число в регистр eax
add sum1,eax    ;складываем элементы первого столбца
add rsi,4       ;переходим на следующую строку
mov eax,[rsi]   ;загружаем число в регистр eax
add sum1,eax    ;складываем элементы первого столбца
add rsi,4       ;переходим на следующую строку
mov eax,[rsi]   ;загружаем число в регистр eax
add sum1,eax    ;складываем элементы первого столбца
add rsi,4       ;переходим на следующую строку
mov eax,[rsi]   ;загружаем число в регистр eax
add sum1,eax    ;складываем элементы первого столбца

lea rsi,mas1   
add rsi,20      
mov eax,[rsi]  
mov sum2,eax
add rsi,4      
mov eax,[rsi]  
add sum2,eax
add rsi,4      
mov eax,[rsi]  
add sum2,eax
add rsi,4      
mov eax,[rsi]  
add sum2,eax
add rsi,4      
mov eax,[rsi]  
add sum2,eax

lea rsi,mas1   
add rsi,40      
mov eax,[rsi]  
mov sum3,eax
add rsi,4      
mov eax,[rsi]  
add sum3,eax
add rsi,4      
mov eax,[rsi]  
add sum3,eax
add rsi,4      
mov eax,[rsi]  
add sum3,eax
add rsi,4      
mov eax,[rsi]  
add sum3,eax

mov eax, sum1;
mov ebx, sum2;
cmp eax, ebx ;  1>2
ja ma
mov eax, sum2;  
mov ebx, sum3;
cmp eax, ebx ;  2>3
ja mc
mov res,3
jmp exit
ma: 
mov eax, sum1;
mov ebx, sum3;
cmp eax, ebx ;  1>3
ja mb
mov res,3
jmp exit
mb:
mov res,1
jmp exit
mc:
mov res,2

exit:
invoke wsprintf, ADDR buf1, ADDR fmt, res
invoke MessageBox,0,addr buf1,addr titl,MB_ICONEXCLAMATION
exit2:
invoke RtlExitUserProcess,0 ;ExitProcess,0
WinMain endp
end