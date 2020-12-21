.686 	           
.model flat, stdcall 
option casemap:none 
include \masm32\include\windows.inc ; 
include \masm32\macros\macros.asm
uselib user32,kernel32,masm32
DATE_SIZE EQU 40
TIME_SIZE EQU 70
.data
szDFormat DB ' Дата: yyyy-MM-dd',0
szTFormat DB "'Время:'HH-mm-ss; ",0
szDate db DATE_SIZE dup(0)
szTime db TIME_SIZE dup(0)
_title db "Дата и время",0
.code
start:
invoke GetDateFormat, LOCALE_USER_DEFAULT,0,0,addr szDFormat, addr szDate, DATE_SIZE
invoke GetTimeFormat, LOCALE_USER_DEFAULT,0,0, ADDR szTFormat, ADDR szTime, TIME_SIZE
invoke lstrcat,ADDR szTime,ADDR szDate; соединение одной строки в конец другой
invoke MessageBox,0,ADDR szTime,ADDR _title,MB_OK