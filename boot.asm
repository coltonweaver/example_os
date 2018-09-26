[org 0x7c00]
    mov bp, 0x9000 ; set the stack
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print ; Written after BIOS messages

    call switch_to_pm
    jmp $ ; Never actually executes.

; Includes
%include 'boot_print.asm'
%include 'boot_print_hex.asm'
%include 'boot_disk.asm'
%include '32bit-gdt.asm'
%include '32bit-switch.asm'
%include '32bit-print.asm'

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    ; Infinite loop.
    jmp $

MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55