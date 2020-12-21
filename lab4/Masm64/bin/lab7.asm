include win64a.inc
.data ;
mas1 db 'The grass is always greener   on the other side of  the fence' ; массив байтов с символами кода ASCII
len1 equ $-mas1 ; определение количества байтов в массиве mas1
titl db " Результат",0 ; назва вікна
buf db ?,0 ; буфер вывода сообщения
ifmt db "кол-во слов, состоящих более чем из четырех букв %d",10,10,
"Автор программы: Хижняк А.С., каф. ВТП, НТУ ХПИ",0
.code
WinMain proc
sub rsp,28h; выравнивание стека 28h=40d=32d+8; 8 - возврат
mov rbp,rsp

xor r11, r11
lea rdi,mas1 ; загрузка адреса массива mas1
mov rax, ' ' ; загрузка символа ‘f’
mov rcx,len1 ; установить в счетчик max значение букв

c3:
cld ; направление - вверх
scasb
jz m2

add r10, 1
cmp r10, 5

jnz m3

add r11, 1
jmp m3

m2:
xor r10, r10
m3:
loop c3 

invoke wsprintf,ADDR buf,ADDR ifmt,r11 ;
invoke MessageBox,0,addr buf,addr titl,MB_OK
ret
WinMain endp
end
