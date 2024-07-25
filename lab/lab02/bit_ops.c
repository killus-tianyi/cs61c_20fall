#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x, unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns 
    // 0 or 1)
    return (x >> n) & 01;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x, unsigned n, unsigned v) {
    // YOUR CODE HERE
    if (v)
    {
        v = v << n;
        *x = *x | v;
    }
    else
    {
        int tmpt = ~(1 << n);
        *x = *x & tmpt;
    }
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
}
void flip_bit(unsigned * x, unsigned n) {
    // YOUR CODE HERE
    int tmpt = get_bit(*x, n) ^ 1;
    set_bit(x, n, tmpt);
}


