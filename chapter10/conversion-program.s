.section __DATA,__data

tmp_buffer:
    .ascii "\0\0\0\0\0\0\0\0\0\0\0"

format:
    .asciz "Result is %s\n"

.section __TEXT,__text

.globl _main

_main:
    movq %rsp, %rbp

    # push the storage buffer
    leaq tmp_buffer(%rip), %rdi
    pushq %rdi

    # convert the number
    pushq $5294
    call integer2string
    addq $8, %rsp

    # print out the number as string
    leaq  tmp_buffer(%rip), %rsi
    leaq  format(%rip), %rdi
    callq _printf

    # exit program
    movq $0, %rdi
    callq _exit
