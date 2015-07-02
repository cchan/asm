http://forum.codecall.net/topic/65222-intro-to-win32-assembly-using-nasm-part-1/
http://forum.codecall.net/topic/65223-intro-to-win32-assembly-using-nasm-part-2/
http://forum.codecall.net/topic/65224-intro-to-win32-assembly-using-nasm-part-3/

SYNOPSIS
========

INSTALL
Install stuff using the above tutorials. NASM and ALINK. Put them in your path.

CODE
Use the sample code in hello.asm.

ASSEMBLE
nasm -f obj hello.asm

LINK
alink -oPE hello.obj

RUN
hello.exe
