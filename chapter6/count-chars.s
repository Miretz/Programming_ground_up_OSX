#PURPOSE:  Count the characters until a null byte is reached
#
#INPUT:    The address of the character string
#
#OUTPUT:   Returns the count in %eax
#
#PROCESS:
#   Registers used:
#       %rcx - character count
#       %al  - current character
#       %rdx - current character address

.globl count_chars

.equ ST_STRING_START_ADDRESS, 16

count_chars:
    pushq %rbp
    movq  %rsp, %rbp

    movq  $0, %rcx  # set the counter to zero
    movq  ST_STRING_START_ADDRESS(%rbp), %rdx

count_loop_begin:
    movb  (%rdx), %al   # grab current character
    cmpb  $0, %al       # is it null?
    je count_loop_end   # if yes, we are done
    incq %rcx           # increment the counter
    incq %rdx           # increment the pointer
    jmp  count_loop_begin  # go back to the beginning
                           # of the loop

count_loop_end:
    movq %rcx, %rax     # move the count into %rax
    popq %rbp
    ret

