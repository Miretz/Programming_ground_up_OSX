#PURPOSE:    Given a number, this program computes the
#            factorial. For example, the factorial of
#            3 is 3 * 2 * 1, or 6. The factorial of
#            4 is 4 * 3 * 2 * 1, or 24, and so on.

.section __DATA,__data

format: .asciz "The factorial of %d is %d.\n"

.section __TEXT,__text

.equ ST_ARGV_1, 8    # input argument

.globl _main
_main:
    dec %rdi         # check number of arguments
    cmpq $1, %rdi    # we need exactly 1 argument
    jne set_default  # wrong number of args, 
                     # use default value

    # align the stack - needed in 64 bit asm
    and $-16, %rsp

    movq ST_ARGV_1(%rsi), %rdi # read the argument
    
    # convert string argument to integer
    callq _atoi
    addq $8, %rsp

    movq %rax, %rbx
    jmp continue_factorial     # continue factorial

set_default:
    movq $4, %rbx   # set a default value

continue_factorial:
    pushq %rbx      # the number input for the
                    # factorial function
    call factorial  # run the factorial function

print_result:
    # printf the result
    leaq  format(%rip), %rdi
    movq  %rbx, %rsi
    movq  %rax, %rdx
    movq  %rax, %rax    # cleanup
    callq _printf

    movl $0x2000001,%eax
    movl $0, %edi
    syscall

