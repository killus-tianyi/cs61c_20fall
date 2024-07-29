.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi t0 x0 1
    blt a2 t0 error_num
    blt a3 t0 error_str
    blt a4 t0 error_str

    add t0 x0 x0
    add t2 x0 x0
    add t4 x0 x0
    add t5 x0 x0
    ebreak
    loop_start:
        beq x0 a2 loop_end
        add t1 t0 x0
        slli t1 t1 2
        add t1 t1 a0
        lw t1 0(t1)

        add t3 t2 x0
        slli t3 t3 2
        add t3 t3 a1
        lw t3 0(t3)

        mul t4 t3 t1
        add t5 t5 t4

        add t0 t0 a3
        add t2 t2 a4
        addi a2 a2 -1
        j loop_start
    loop_end:
        add a0 x0 t5
        jr ra
    
    error_num:
        li a0 36
        j exit

    error_str:
        li a0 37
        j exit
