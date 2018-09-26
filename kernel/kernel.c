#include "../drivers/ports.h"

void main() {
    /* Screen cursor position: ask VGA control register (0x3d4) for bytes
     * 14 = high byte of cursor and 15 = low byte of cursor. */
    port_byte_out(0x3d4, 14);
    /* Data is returned in VGA data register (0x3d5) */
    int position = port_byte_in(0x3d5);
    position = position << 8; /* This was the high byte */

    /* Now retrieve the low byte */
    port_byte_out(0x3d4, 15);
    position += port_byte_in(0x3d5);

    /* VGA 'cells' consist of the character and its control data
     * e.g. 'white on black background', 'red text on white bg', etc */
    int offset_from_vga = position * 2;

    /* Now you can examine both variables using gdb, since we still
     * don't know how to print strings on screen. Run 'make debug' and
     * on the gdb console:
     * breakpoint kernel.c:21
     * continue
     * print position
     * print offset_from_vga
    */

    char * vga = 0xb8000;
    vga[offset_from_vga] = 'X';
    vga[offset_from_vga+1] = 0x0f; 
}