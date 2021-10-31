#PURPOSE:  Compare 2 strings up to 5 characters
#
#INPUT:    The address of the first character string
#          The address of the second character string 
#
#OUTPUT:   Returns 1 in %eax if they match
#          Returns 0 if they don't
#

.globl compare_strings

.equ ST_STRING_1, 16
.equ ST_STRING_2, 24

compare_strings:
    pushq %rbp
    movq  %rsp, %rbp

    movq  $0, %rsi

    movq  ST_STRING_1(%rbp), %rcx
    movq  ST_STRING_2(%rbp), %rdx

compare_loop_begin:
    
    movb  (%rcx), %al   # grab character of string 1
    movb  (%rdx), %bl   # grab character of string 2

    cmpb  %al, %bl      # are the characters equal
    jne return_false    # return false if not equal
    
    cmpb  $0, %al       # is it null?
    je return_true      # if yes, we are done
   
    incq %rsi           # increment the counter
    incq %rcx           # increment the pointer
    incq %rdx           # increment the pointer
    
    cmpq $5, %rsi       # we compared 5 characters
    je return_true      # return true

    jmp  compare_loop_begin  # go back to the beginning
                            # of the loop
return_true:
    movq $1, %rax     # move the result into %rax
    popq %rbp
    ret

return_false:
    movq $0, %rax
    popq %rbp
    ret

