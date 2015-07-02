;; When symbols are not defined within our program, we need to use 'extern', to tell NASM that those will be assigned when the program is linked. 
;; These are the symbols for the Win32 API import functions we will use. 
extern GetStdHandle 
extern WriteFile 
extern AllocConsole 
extern FreeConsole 
extern SetConsoleTitleA 
extern SetConsoleCursorPosition 
extern Sleep 
extern ExitProcess 

;; Now, we need a symbol import table, so that we can import Win32 API functions from their DLLs. 
;; Note, though, that some functions have ANSI and unicode versions; for those, a name suffix is 
;; required (ie "<function_name>A" for ANSI, and "<function_name>W" for unicode; SetConsoleTitleA 
;; is an example of one). 
import GetStdHandle kernel32.dll 
import WriteFile kernel32.dll 
import AllocConsole kernel32.dll 
import FreeConsole kernel32.dll 
import SetConsoleTitleA kernel32.dll 
import SetConsoleCursorPosition kernel32.dll 
import Sleep kernel32.dll 
import ExitProcess kernel32.dll 

section .text use32 

..start: 

call [AllocConsole] ; Hm. ASM seems to treat data and functions much the same. In fact, it's all bytes.
					; So a functional programming language that goes directly to ASM should not be overly complex, and would be immensely fast.
					; or func pointers in C would be easier because C easier than ASM

push dword the_title 
call [SetConsoleTitleA] 

;Push parameter for STD_OUTPUT_HANDLE, GetStdHandle for that, and move that handle to hStdOut
push dword -11 ; Windows constant for STD_OUTPUT_HANDLE
call [GetStdHandle] 
mov dword [hStdOut], eax 

;Get msg_len
mov eax, msg_len 
sub eax, msg ;Address arithmetic.
dec eax ;remove trailing zero
mov dword [msg_len], eax 

;; WriteFile() has 5 parameters. 
push dword 0 ;param 5
push dword nBytes ;param 4: where actual # of bytes written will be saved
push dword [msg_len] ;param 3: number of bytes to write
push dword msg ;param 2: pointer to buffer
push dword [hStdOut] ;param 1: handle for file to write to - that is, STDOUT.
call [WriteFile] 

mov ax, 15 ;low-order
shl eax, 16 ;shift to high order: Y
mov ax, 14 ;low-order: X
push eax ; param 2: the data we just made actually is a COORD structure. It's two 16bit ints.
push dword [hStdOut] ; param 1: handle of console: STDOUT.
call [SetConsoleCursorPosition] ; same as "push EIP + jmp [SetConsoleCursorPosition]" but can't access EIP directly

push 2000
call [Sleep]

call [FreeConsole] ; ***where is it getting the handle from

xor eax, eax ;Clear eax
push eax 
call [ExitProcess] ;and so return 0


section .data 
the_title                  db "HelloWorldProgram", 0 
msg                        db "Hello World! ", 13, 10, 0 
msg_len						dd 0 ;Needs to be right after msg in the data section based on how we did the above\

section .bss  ;reserve two doublewords
hStdOut                    resd 1 
nBytes                     resd 1 
