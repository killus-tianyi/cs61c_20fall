#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t temp = *reg;
    uint8_t bit[] = {0, 2, 3, 5};
    for (int i = 0; i < 4; i++) {
        bit[i] = (temp >> bit[i]) & 1;
        temp = *reg;
    }
    *reg = ((bit[0]^bit[1]^bit[2]^bit[3]) << 15) | (*reg >> 1);
}

