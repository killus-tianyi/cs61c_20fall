.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:

    # if a1 < 1 , return 
    addi t0 x0 1
    blt a1 t0 EXCE

    #iterate the array
    addi t1 x0 0
    ebreak
loop_start:
    beq t1 a1 loop_end
    # if the value is less than 0, set the items as 0, otherwise continue the loop_continue
    slli t2 t1 2
    add t2 t2 a0
    lw t3 0(t2)
    bge t3 x0 loop_continue
    sw x0 0(t2)
    loop_continue: addi t1 t1 1
    j loop_start
loop_end:
    jr ra

EXCE:
    li a0 36
    j exit






