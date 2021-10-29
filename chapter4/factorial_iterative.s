#PURPOSE:    Given a number, this program computes the
#            factorial. For example, the factorial of
#            3 is 3 * 2 * 1, or 6. The factorial of
#            4 is 4 * 3 * 2 * 1, or 24, and so on.

# Factorial iterative version

# This program has no global data
.section __DATA,__data
.section __TEXT,__text

.globl _main
_main:
    pushq $4        # the number input for the
                    # factorial function
    call factorial  # run the factorial function
    addq  $4, %rsp  # scrubs the parameter that was pushed
                    # on the stack
    movq %rax, %rdi # factorial returns the answer
                    # in %rax, but we need it in %rdi
                    # to send it as our exit status

    movl $0x2000001,%eax
    syscall

factorial:
    pushq %rbp      # standard function stuff - we have to
                    # restore %rbp to its prior state before
                    # returning, so we have to push it
    movq %rsp, %rbp # This is because we don't want to modify
                    # the stack pointer, so we use %rbp.
    movq 16(%rbp), %rax
                    # This moves the first argument to %rax
                    # 8(%rbp) holds the return address, and
                    # 16(%rbp) holds the first parameter
    movq %rax, %rbx # %rbx will accumulate the sum

factorial_loop:
    cmpq $1, %rax      # If the number is 1, stop iteration
    je end_factorial   # jump to end the factorial loop
    decq %rax          # otherwise, decrease the value
    imulq %rax, %rbx   # multiply with %rbx and accumulate
                       # in %rbx
    jmp factorial_loop # continue looping

end_factorial:
    movq %rbx, %rax # move teh result to %rax
    movq %rbp, %rsp # standard function return stuff - we
                    # have to restore %rbp and %rsp to
    popq %rbp       # they were before the function started
    ret             # return to the caller (this pops the
                    # return value too.
