#PURPOSE: This program writes the message "hello world"
#         and exits

.include "../chapter6/osx.s"

.section __DATA,__data

helloworld: 
    .ascii "hello world\n"
    helloworld_len = . - helloworld

.section __TEXT,__text

.globl _main

_main:
    # write hello world to STDOUT
    movq  $SYS_WRITE, %rax
    movq  $STDOUT, %rdi
    leaq  helloworld(%rip), %rsi
    movq  $helloworld_len, %rdx
    syscall

    # exit program
    movq $SYS_EXIT, %rax
    movl $0, %edi
    syscall
