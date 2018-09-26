[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; The same one we used when linking the kernel
    mov [BOOT_DRIVE], dl ; Remember that BIOS sets the boot drive in the 'dl' on boot
    mov bp, 0x9000 ; set the stack
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print ; Written after BIOS messages
    call print_nl

    call load_kernel ; read kernel from disk
    call switch_to_pm ; disable interrupts, load GDT, etc.
    jmp $ ; Never actually executes.

; Includes
%include 'boot/boot_print.asm'
%include 'boot/boot_print_hex.asm'
%include 'boot/boot_disk.asm'
%include 'boot/32bit-gdt.asm'
%include 'boot/32bit-switch.asm'
%include 'boot/32bit-print.asm'

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET
    jmp $

BOOT_DRIVE db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55