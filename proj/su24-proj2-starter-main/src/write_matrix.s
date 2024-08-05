.globl write_matrix

.data 
    temp1: .word  0
    temp2: .word  0

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -4
    sw ra 0(sp)

    # open the file
    addi sp sp -12
    sw a1 8(sp)
    sw a2 4(sp)
    sw a3 0(sp)

    li a1 1
    jal ra fopen
    li t1 -1
    beq a0 t1 error_fopen

    lw a3 0(sp)
    lw a2 4(sp)
    lw a1 8(sp)
    addi sp sp 12

    # write the row into the file
    la t0 temp1
    sw a2 0(t0)
    addi sp sp -16
    sw a0 12(sp)
    sw a1 8(sp)
    sw a2 4(sp)
    sw a3 0(sp)

    add a1 x0 t0
    li a2 1
    li a3 4
    jal ra fwrite

    li t3 1
    bne t3 a0 error_fwrite
    lw a3 0(sp)
    lw a2 4(sp)
    lw a1 8(sp)
    lw a0 12(sp)
    addi sp sp 16


    # write col into the file
    la t1 temp2
    sw a3 0(t1)
    addi sp sp -16
    sw a0 12(sp)
    sw a1 8(sp)
    sw a2 4(sp)
    sw a3 0(sp)

    add a1 x0 t1
    li a2 1
    li a3 4
    jal ra fwrite
    li t3 1
    bne t3 a0 error_fwrite
    lw a3 0(sp)
    lw a2 4(sp)
    lw a1 8(sp)
    lw a0 12(sp)
    addi sp sp 16

    # write the item into the file
    mul a2 a2 a3
    addi sp sp -8
    sw a0 4(sp)
    sw a2 0(sp)


    li a3 4
    jal ra fwrite
    lw a2 0(sp)
    bne a2 a0 error_fwrite
    lw a0 4(sp)
    addi sp sp 8
    jal ra fclose
    li t1 -1
    beq a0 t1 error_fclose
    # Epilogue
    lw ra 0(sp)
    addi sp sp 4

    jr ra

    error_fopen:
        li a0 27
        j exit
    
    error_fwrite:
        li a0 30
        j exit
    
    error_fclose:
        li a0 28
        j exit
