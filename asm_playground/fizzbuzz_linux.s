#PURPOSE: This program goes over the range of numbers until 20
#         It prints "fizz" in case the number is divisible by 3.
#         It prints "buzz" in case the number is divisible by 5.
#         Otherwise prints the number.

# Linux version tested on Ubuntu

.section .data

# format strings
number_format: .asciz "%d\n"
fizz: .asciz "fizz\n"
buzz: .asciz "buzz\n"
fizzbuzz: .asciz "fizzbuzz\n"
newline: .asciz "\n"

.section .text

.equ MAX, 30

.global main
main:
    movq $0, %rcx     # counter

fb_loop:
    incq %rcx         # increment counter
    cmpq $MAX, %rcx   # check if we reached the limit
    je end_loop       # end iteration

    xor  %rdx, %rdx   # clear rdx for division
    movq %rcx, %rax   # prepare for division

    movq $15, %rdi    # check fizzbuzz - 
    divq %rdi         # divide %rax by %rdi
    cmpq $0, %rdx     # %rax = result, %rdx = remainder
    je print_fizzbuzz # jump to print function

    xor  %rdx, %rdx
    movq %rcx, %rax   # prepare for division

    movq $3, %rdi     # check fizz
    divq %rdi
    cmpq $0, %rdx
    je print_fizz

    xor  %rdx, %rdx
    movq %rcx, %rax   # prepare for division

    movq $5, %rdi     # check buzz
    divq %rdi
    cmpq $0, %rdx
    je print_buzz

    jmp print_number  # print the number

print_fizzbuzz:
    pushq %rcx

    leaq fizzbuzz(%rip), %rdi
    callq printf

    popq %rcx
    jmp fb_loop

print_fizz:
    pushq %rcx

    leaq fizz(%rip), %rdi
    callq printf

    popq %rcx
    jmp fb_loop

print_buzz:
    pushq %rcx

    leaq buzz(%rip), %rdi
    callq printf

    popq %rcx
    jmp fb_loop

print_number:
    pushq %rcx

    movq %rcx, %rsi        # pass the number to printf
    xor  %rax, %rax        # because printf is varargs
    leaq  number_format(%rip), %rdi  # format string
    callq printf
    
    popq %rcx
    jmp fb_loop

end_loop:
    addq $8, %rsp
    movq $0, %rdi
    callq exit
