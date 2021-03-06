#PURPOSE:    Program to illustrate how functions work
#            This program will compute the value of
#            2^3 + 5^2

# Everything in the main program is stored in registers
# so the data section doesn't have anything

.section __DATA,__data
.section __TEXT,__text
.globl _main
_main:
    pushq $3            # push second argument
    pushq $2            # push first argument
    call power          # call the function
    addq $16, %rsp      # move the stack pointer back
    pushq %rax          # save the first answer
                        # before calling the next function
    pushq $0            # push second argument
    pushq $5            # push first argument
    call power          # call the function
    addq $16, %rsp      # move the stack pointer back

    popq %rbx           # the second answer is already
                        # in %rax. We saved the first
                        # answer onto the stack,
                        # so now we can just pop it
                        # out into %rbx

    addq %rax, %rbx     # add them together
                        # the result is in %ebx

    movl $0x2000001,%eax # exit (%rbx is returned)
    movq %rbx, %rdi
    syscall

#PURPOSE:   This function is used to compute
#           the value of a number raised to
#           a power.

#INPUT:     First argument - the base number
#           Second argument - the power to
#                             raise it to

#OUTPUT:    Will get the result as return value
#
#VARIABLES:
#           %rbx - holds the base number
#           %rcx - holds the power
#           -8(%rbp) - holds the current result
#           %rax is used for temporary storage
#

power:
    pushq %rbp           # save old base pointer
    movq  %rsp, %rbp     # make stack pointer the base pointer
    subq  $8, %rsp       # get room for our local storage

    movq 16(%rbp),%rbx   # put first argument into %rbx
    movq 24(%rbp),%rcx   # put second argument into %rcx
    movq %rbx, -8(%rbp)  # store current result
    cmpq $0, %rcx        # anything raised to the power of
                         # zero is 1
    jne power_loop_start # is not zero, run the calculation
    movq $1, -8(%rbp)    # store 1 as result
    jmp end_power        # jump to the end

power_loop_start:
    cmpq $1, %rcx        # if the power is 1, we are done
    je end_power
    movq -8(%rbp), %rax  # move the current result into %rax
    imulq %rbx, %rax     # multiply the current result by
                         # the base number
    movq %rax, -8(%rbp)  # store the current result
    decq %rcx            # decrease the power
    jmp power_loop_start # run for the next power

end_power:
    movq -8(%rbp), %rax # return value goes in %rax
    movq %rbp, %rsp     # restore the stack pointer
    popq %rbp           # restore the base pointer
    ret
