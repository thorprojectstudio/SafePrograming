cls
set masm64_path=\masm64\
set filename=%1
if exist %filename%.exe del %filename%.exe
if exist %filename%.obj del %filename%.obj
if exist errors.txt del errors.txt
%masm64_path%bin\ml64 /Cp /c /I"%masm64_path%Include" %filename%.asm >> errors.txt
if errorlevel 1 goto errasm
%masm64_path%bin\link /SUBSYSTEM:CONSOLE /LIBPATH:"%masm64_path%Lib" ^
/entry:WinMain %filename%.obj >> errors.txt
if errorlevel 1 goto errasm
del %filename%.obj
del errors.txt
exit
:errasm
%masm64_path%topgun.exe errors.txt
