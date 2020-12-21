; параллельное сложение с помощью ћћ’-команд над массивами целых чисел.
; если второе слово больше 55, то выполнить операцию
; a Ч c/b Ч dc  (-4,83), де a = 2,7; b = 8,05; c = 2,2; d = 3,3;
; иначе Ч выполнить операцию a Ц c/b   (2,43)

include win64a.inc

fpuDiv macro _a,_c,_b ; макрос с именем fpuDiv
fld _c
fdiv _b
fld _a
fsubr
endm ;; окончание макроса

.data

_a REAL4 2.8
_b REAL4 8.05
_c REAL4 2.2
_d REAL4 3.3

arr1 dw 1,25,3,4          ; массив чисел arr1 размером в слово
len1 equ ($-arr1)/type arr1  ; количество чисел массива
arr2 dw 5,31,7,5        ; массив чисел arr2 размером в слово
len2 equ ($-arr2)/type arr2    ; количество чисел массива
arr1_2 dw len1 dup(0) ; размер буфера дл€ чисел массивов

tit1 db "masm64. Oперации MMX-FPU",0  ; название окошка
st2 dd 0             ; буфер чисел дл€ вывода сообщени€
buf1 db 0,0
buf2 dq 1 dup(0);
ifmt db "  ѕараллельное сложение с помощью ммх-команд над массивами целых чисел.",10,
"≈сли второе слово больше 55, то выполнить операцию:",10,
"a Ч c/b Ч dc  (-4,83), где a = 2,7; b = 8,05; c = 2,2; d = 3,3;",10,
"»наче Ч выполнить операцию a Ч c/b   (2,43)",10,10,"ќтвет =  %d ",10,10,
"јвтор: –ысованый ј.Ќ., каф. ¬“ѕ, Ќ“” ’ѕ»",10,
9,"сайт:  http://blogs.kpi.kharkov.ua/v2/asm/",0


.code
WinMain proc
sub rsp,28h; cтек: 28h=32d+8; 32d x 8 = 256/16=16 байт;8 Ч возврат
mov rbp,rsp
movq MM1,QWORD PTR arr1  ; загрузка массива чисел arr1
movq MM2,QWORD PTR arr2 ; загрузка массива чисел arr2
paddw MM1,MM2     ; параллельное циклическое сложение
movq QWORD PTR arr1_2,MM1       ; сохранение результата
pextrw eax,MM1,1   ; копирование первого после нулевого слова в eax
emms               ; последн€€ ммх-команда
cmp eax,55
jg @2 ; if >

@1:   fpuDiv [_a],[_c],[_b] 
jmp m1

@2:   fpuDiv [_a],[_c],[_b] 
fld _d
fmul _c
fsub
m1: fisttp st2 ; сохранение только целой  части
invoke wsprintf,ADDR buf1,ADDR ifmt,st2  
invoke MessageBox, NULL, addr buf1, addr ifmt, MB_ICONINFORMATION
invoke ExitProcess,0

WinMain endp
end