OPTION DOTNAME
OPTION PROLOGUE:rbpFramePrologue
OPTION EPILOGUE:none
include win64.inc
include temphls.inc
include kernel32.inc
includelib kernel32.lib
include ntdll.inc
includelib ntdll.lib
include user32.inc
includelib user32.lib

include gdi32.inc
includelib gdi32.lib
;---------------------------------
include comctl32.inc
includelib comctl32.lib
include comdlg32.inc
includelib comdlg32.lib
include shell32.inc
includelib shell32.lib

;--------------------------------
;include ole32.inc
;includelib ole32.lib