#include "mem.h"

void mem_copy(u8 * src, u8 * dst, int nbytes) {
    int i;
    for (i = 0; i < nbytes; i++) {
        *(dst + i) = *(src + i);
    }
}

void mem_set(u8 * dst, u8 val, u32 len) {
    u8 * temp = (u8 *) dst;
    for (; len != 0; len--) *temp++ = val;
}