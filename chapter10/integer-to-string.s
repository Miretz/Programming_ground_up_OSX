#PURPOSE: Convert an integer number to a decimal string
#         for display
#
#INPUT:   A buffer large enough to hold the largest
#         possible number
#         An integer to convert
#
#OUTPUT:  The buffer will be overwritten with the
#         decimal string
#
#Variables:
#
# %ecx will hold the count of characters processed
# %eax will hold the current value
# %edi will hold the base (10)
#

.equ ST_VALUE, 16
.equ ST_BUFFER, 24

.globl integer2string
integer2string:
    pushq %rbp
    movq  %rsp, %rbp

    movq  $0, %rcx  # current character count
    movq  ST_VALUE(%rbp), %rax # move the value to position

    movq  $10, %rdi  # for division by 10

conversion_loop:
    movq   $0, %rdx   # clear out %rdx
    divq   %rdi       # divide %rdx:%rax
    addq   $'0', %rdx # convert to char
    pushq  %rdx       # push to the stack
    incq   %rcx       # increment counter
    cmpq   $0, %rax   # check if %rax is below 0
    je end_conversion_loop
    jmp conversion_loop

end_conversion_loop: # the string is now on the stack
    movq   ST_BUFFER(%rbp), %rdx 

copy_reversing_loop:
    popq   %rax # pop entire register
    movb   %al, (%rdx) # move byte by byte
    decq   %rcx        # decreasing counter
    incq   %rdx        # increasing string pointer

    cmpq   $0, %rcx    # check if we are finished
    je end_copy_reversing_loop
    jmp copy_reversing_loop

end_copy_reversing_loop:
    movb $0, (%rdx)    # write a null byte

    movq %rbp, %rsp
    popq %rbp
    ret

