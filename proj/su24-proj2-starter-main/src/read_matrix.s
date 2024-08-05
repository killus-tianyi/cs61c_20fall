.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -12
    sw ra 8(sp)
    sw s0 4(sp)
    sw s1 0(sp)

    # open the file 
    addi sp sp -8
    sw a2 4(sp)
    sw a1 0(sp)
    li a1 0
    jal ra fopen
    li t3 -1
    beq a0 t3 error_fopen 
    lw a1 0(sp)
    lw a2 4(sp)
    addi sp sp 8
    # read the row/col
    addi sp sp -12
    sw a1 8(sp)
    sw a2 4(sp)
    sw a0 0(sp)
    li a2 4
    jal ra fread
    li t3 4
    bne a0 t3 error_fread
    lw a0 0(sp)
    lw a2 4(sp)
    lw a1 8(sp)
    addi sp sp 12

    addi sp sp -12
    sw a1 8(sp)
    sw a2 4(sp)
    sw a0 0(sp)
    add a1 x0 a2
    li a2 4 
    jal ra fread
    li t3 4
    bne a0 t3 error_fread
    lw a0 0(sp)
    lw a2 4(sp)
    lw a1 8(sp)
    addi sp sp 12

    # create the space 
    lw t0 0(a1)
    lw t1 0(a2)
    mul t0 t0 t1

    addi sp sp -16
    sw t0 12(sp)
    sw a1 8(sp)
    sw a2 4(sp)
    sw a0 0(sp)
    add a0 x0 t0
    slli a0 a0 2
    jal ra malloc 
    beqz a0 error_malloc # exit if malloc failed
    add s0 a0 x0 # the head pointer
    add s1 a0 x0 # iterate the region
    lw a0 0(sp)
    lw a2 4(sp)
    lw a1 8(sp)
    lw t0 12(sp)
    addi sp sp 16 

    # iterate the entire file
    loop:
        beq x0 t0 end_loop
            addi sp sp -16
            sw t0 12(sp)
            sw a1 8(sp)
            sw a2 4(sp)
            sw a0 0(sp)
            add a1 x0 s1
            li a2 4
            jal ra fread
            li t3 4
            bne a0 t3 error_fread
            lw a0 0(sp)
            lw a2 4(sp)
            lw a1 8(sp)
            lw t0 12(sp)
            addi sp sp 16 
        addi s1 s1 4
        addi t0 t0 -1
        j loop
    end_loop:
    #clsoe the file
    jal ra fclose
    li t3 -1
    beq a0 t3 error_fclose
    add a0 x0 s0

    # Epilogue
    lw s1 0(sp) 
    lw s0 4(sp)
    lw ra 8(sp)
    addi sp sp 12
    jr ra

error_malloc:
    li a0 26
    j exit

error_fopen:
    li a0 27
    j exit

error_fclose:
    li a0 28
    j exit

error_fread:
    li a0 29
    j exit