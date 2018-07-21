[bits 32] ; Protected Mode
[extern main] ; Tell the nasm compiler that "main" exsists somewhere
call main
jmp $ ; When we return from  the kernel we are here
