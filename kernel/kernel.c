#include "kernel.h"
#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "../libc/string.h"

void main() {
    clear_screen();
    isr_install();
    irq_install();

    kprint("Welcome to Colton's OS!\n");
    kprint(">");
}

void user_input(char * input) {
    if (strcmp(input, "END") == 0) {
        kprint("Halting the CPU...");
        asm volatile("hlt");
    }
    kprint("You said: ");
    kprint(input);
    kprint("\n>");
}