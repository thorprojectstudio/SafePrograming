;include win64a.inc
OPTION DOTNAME ; вкл. и отключение функции ассемблера
include temphls.inc
include win64.inc
include kernel32.inc
includelib kernel32.lib
include user32.inc
includelib user32.lib
OPTION PROLOGUE:none
OPTION EPILOGUE:none

.DATA ; директива начала сегмента данных
X DW 5 ; резервирование в памяти 2-х байтов для переменной Х
Y DW 3 ; резервирование в памяти 2-х байтов для переменной Y
Z DW ? ; резервирование в памяти 2-х байтов для переменной Z
titl db "masm64. Вывод через функцию MessageBox",0; название упрощенного окна
st1 dw ?,0 ; буфер выведения сообщения. dw для небольших чисел
ifmt db "Вывод чисел с памяти через MessageBox:", 0dh,0ah,
"а = 12", 0dh,0ah, 'c = 97', 0dh,0ah,
"a - c = -%d", 0dh,0ah,0ah, ; задание превращения символа
"Автор программы: , КИТ26B",0 


.CODE ; директива начала сегмента команд
WinMain proc
sub rsp,28h; выравнивание стека 28h=40d=32d+8; 8 - возврат
mov rbp,rsp

MOV AX,X ; загрузка операнда Х
ADD AX,Y ; сложение операндов Х и Y
MOV Z,AX ; сохранение результата в памяти в ячейке с именем Z
invoke wsprintf,ADDR st1,ADDR ifmt,Z
invoke MessageBox,0,addr st1,addr titl,MB_ICONINFORMATION
invoke ExitProcess, 0 ;
WinMain endp
end