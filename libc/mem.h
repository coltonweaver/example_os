#ifndef MEM_H
#define MEM_H

#include "../cpu/types.h"

void mem_copy(u8 * src, u8 * dst, int nbytes);
void mem_set(u8 * dst, u8 val, u32 len);

#endif