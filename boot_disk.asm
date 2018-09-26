; load 'dh' sectors from drive 'd1' into ES:BX
disk_load:
    pusha

    ; Reading from disk requires specific params, so save what is in current regs
    push dx

    mov ah, 0x02    ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, dh      ; al <- number of sectors to read (0x01 .. 0x80)
    mov cl, 0x02    ; cl <- sector (0x01 .. 0x11)
                    ; 0x01 is the boot sector, 0x02 is the first 'available' sector
    mov ch, 0x00    ; ch <- cylinder (0x0 .. 0x3FF, upper two bits in 'cl')
    ; dl <- drive number. OUr caller sets it as a paramter and gets it from BIOS
    ; (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
    mov dh, 0x00    ; dh <- head number (0x0 .. 0xF)

    ; [es:bx] <- pointer to buffer where the data is actually stored
    ; caller sets it up for us, and it is actually the standard location for int 13h
    int 0x13        ; BIOS interrupt
    jc disk_error   ; jump if carry to disk_error as the carry bit is set on failure

    pop dx
    cmp al, dh      ; BIOS also sets 'al' to the # of sectors read, compare it
    jne sectors_error
    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah ; ah = error code, dl = disk drive that dropped the error
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print
    call print_nl
    jmp disk_loop

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0