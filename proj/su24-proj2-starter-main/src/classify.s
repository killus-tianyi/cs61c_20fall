.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp sp -36
    sw ra 32(sp)
    sw s0 28(sp)
    sw s1 24(sp)
    sw s2 20(sp)
    sw s3 16(sp)
    sw s4 12(sp)
    sw s5 8(sp)
    sw s6 4(sp)
    sw s7 0(sp)
    
    li t0 5
    bne a0 t0 error_num

    # Read pretrained m0 # s0 contain the address of the first item, s1 contain the row and col
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    li a0 8

    jal ra malloc
    beq a0 x0 error_malloc
    add s1 a0 x0
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

   # read the matrix m0 from the m0 file
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    lw a0 4(a1)
    add a1 x0 s1
    addi a2 s1 4
    ebreak
    jal ra read_matrix 
    add s0 a0 x0

    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12    

    # Read pretrained m1
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    li a0 8
    jal ra malloc
    beq a0 x0 error_malloc
    add s3 a0 x0
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

    # read matrix m1 from the m1 file
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    lw a0 8(a1)
    add a1 x0 s3
    addi a2 s3 4
    jal ra read_matrix 
    add s2 a0 x0

    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12    

    # Read input matrix

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    li a0 8
    jal ra malloc
    beq a0 x0 error_malloc
    add s5 a0 x0
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

    # read the matrix from the input file
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    lw a0 12(a1)
    add a1 x0 s5
    addi a2 s5 4
    jal ra read_matrix 
    add s4 a0 x0

    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12    

    # Compute h = matmul(m0, input)
    # calculate the total area for the first destination
    lw t0 0(s1)
    lw t1 4(s5)
    mul t0 t0 t1
    slli t0 t0 2

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    add a0 x0 t0
    jal ra malloc
    beq a0 x0 error_malloc
    add s6 x0 a0
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12        

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    add a0 x0 s0
    lw a1 0(s1)
    lw a2 4(s1)
    add a3 x0 s4
    lw a4 0(s5)
    lw a5 4(s5)
    add a6 x0 s6
    jal ra matmul
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12  

    # Compute h = relu(h)
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    add a0 x0 s6
    lw t0 0(s1)
    lw t1 4(s5)
    mul t0 t0 t1
    add a1 x0 t0
    jal ra relu
    add s6 a0 x0
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12    

    # Compute o = matmul(m1, h)
    lw t0 0(s3)
    lw t1 4(s5)
    mul t0 t0 t1
    slli t0 t0 2

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    add a0 t0 x0
    jal ra malloc
    beq a0 x0 error_malloc
    add s7 a0 x0
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    add a0 s2 x0
    lw a1 0(s3)
    lw a2 4(s3)
    add a3 x0 s6
    lw a4 0(s1)
    lw a5 4(s5)
    add a6 x0 s7
    jal ra matmul
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

    # Write output matrix o

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    lw a0 16(a1)
    add a1 s7 x0
    lw a2 0(s3)
    lw a3 4(s5)
    ebreak
    jal ra write_matrix
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

    # Compute and return argmax(o)
    lw t0 0(s3)
    lw t1 4(s5)
    mul t0 t0 t1

    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    
    add a0 s7 x0
    add a1 t0 x0
    jal ra argmax
    add t3 x0 a0
    
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12

    # If enabled, print argmax(o) and newline
    bne a2 x0 NOTP
    addi sp sp -12
    sw a0 8(sp)
    sw a1 4(sp)
    sw a2 0(sp)
    add a0 x0 t3
    jal ra print_int
    li a0 '\n'
    jal ra print_char
    lw a2 0(sp)
    lw a1 4(sp)
    lw a0 8(sp)
    addi sp sp 12
    NOTP:

    # free all the malloc space
    addi sp sp -4
    sw t3 0(sp)
    add a0 s1 x0
    jal ra free
    add a0 s3 x0
    jal ra free
    add a0 s5 x0
    jal ra free
    add a0 s6 x0
    jal ra free
    add a0 s7 x0
    jal ra free
    lw t3 0(sp) 
    addi sp sp 4

    add a0 t3 x0
    lw s7 0(sp)
    lw s6 4(sp)
    lw s5 8(sp) 
    lw s4 12(sp)
    lw s3 16(sp)
    lw s2 20(sp)
    lw s1 24(sp)
    lw s0 28(sp)
    lw ra 32(sp)
    addi sp sp 36
    jr ra

error_malloc:
    li a0 26
    j exit

error_num:
    li a0 31
    j exit
