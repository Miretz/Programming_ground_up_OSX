#PURPOSE:    Program to illustrate how functions work
#            This program will compute the value of
#            a number squared.

.section __DATA,__data
message: .asciz "The result is %d\n."
.section __TEXT,__text
.globl _main
_main:
    pushq $4               # push argument
    call  square           # call the function

print:                     # this section prints the
                           # number from %rax
    and $-16, %rsp         # align stack before print
    leaq message(%rip), %rdi
                           # push the address of the
                           # format string
    movq %rax, %rsi        # result of square
    xor  %rax, %rax        # because printf is varargs
    callq  _printf         # call printf function

exit:
    movq $0, %rdi          # move status code to %rdi
    movl  $0x2000001, %eax # exit (%rbx is returned)
    syscall                # exit call

#PURPOSE:   This function is used to compute
#           the square value of a number
#
#INPUT:     First argument - the base number
#
#OUTPUT:    Will get the result as return value
#
#VARIABLES:
#           %rbx - holds the base number
#           %rax is used for temporary storage

square:
    pushq %rbp          # save old base pointer
    movq  %rsp, %rbp    # make stack pointer the base pointer
    subq  $8, %rsp      # get room for our local storage

    movq 16(%rbp), %rbx # put first argument into %rbx
    movq 16(%rbp), %rax # put first argument into %rax

    imulq %rbx, %rax    # multiply numbers into %rax

    movq %rbp, %rsp     # restore the stack pointer
    popq %rbp           # restore the base pointer
    ret
