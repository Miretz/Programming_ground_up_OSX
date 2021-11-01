#PURPOSE:    Given a number, this program computes the
#            factorial. For example, the factorial of
#            3 is 3 * 2 * 1, or 6. The factorial of
#            4 is 4 * 3 * 2 * 1, or 24, and so on.

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


