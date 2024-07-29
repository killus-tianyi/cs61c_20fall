.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bne a2 a4 error_match
    li t2 1
    blt a1 t2 error_length
    blt a2 t2 error_length
    blt a4 t2 error_length
    blt a5 t2 error_length
    
    # Prologue
    addi sp sp -8
    sw ra 4(sp)
    sw s0 0(sp)

    li t0 0
    li t1 0
    li t2 0

    # get the number of items in final matrix, store it into s0
    add s0 a6 x0



outer_loop_start:
    beq t0 a1 outer_loop_end
    ebreak
    inner_loop_start:
        beq t1 a5 inner_loop_end
        addi sp sp -32
        sw a0 28(sp)
        sw a1 24(sp)
        sw a2 20(sp)
        sw a3 16(sp)
        sw a5 12(sp)
        sw t0 8(sp)
        sw t1 4(sp)
        sw t2 0(sp)
        

        add a1 x0 a3
        add a2 x0 a2
        addi a3 x0 1
        add a4 x0 a5

        jal ra dot
        sw a0 0(s0)
        addi s0 s0 4

        lw t2 0(sp) 
        lw t1 4(sp) 
        lw t0 8(sp)
        lw a5 12(sp)
        lw a3 16(sp)
        lw a2 20(sp)
        lw a1 24(sp)
        lw a0 28(sp)
        addi sp sp 32

        addi t1 t1 1
        addi a3 a3 4
        j inner_loop_start
    inner_loop_end:
    # set the inner index t1 as 0, and restore the a3 to original index
    slli t2 t1 2
    sub a3 a3 t2
    li t1 0

    addi t0 t0 1

    #move the a0 point to the next row
    slli t2 a2 2
    add a0 a0 t2
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw s0 0(sp)
    lw ra 4(sp)
    addi sp sp 8
    jr ra


error_match:
    li a0 38
    j exit

error_length:
    li a0 38
    j exit
