[bits 32]
[extern main]   ; Define the calling point, must have the same name as the one in kernel.c
call main       ; Calls the C function, the linker will know where this is in memory
jmp $