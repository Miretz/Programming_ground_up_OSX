#PURPOSE: This program writes the message "hello world"
#         and exits

.section __DATA,__data

helloworld: 
    .asciz "hello world\n"

.section __TEXT,__text

.globl _main

_main:
    # write hello world using printf
    leaq  helloworld(%rip), %rdi
    pushq %rdi
    callq _printf

    # exit program
    movq $0, %rdi
    callq _exit
