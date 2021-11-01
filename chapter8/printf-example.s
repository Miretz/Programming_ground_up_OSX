#PURPOSE: This program is to demonstrate how to call printf

.section __DATA,__data

# format string
firststring:
    .asciz "Hello! %s is a %s who loves the number %d\n"

name:
    .asciz "Jonathan"

personstring:
    .asciz "person"

numberloved:
    .long 3

.section __TEXT,__text

.globl _main

_main:
    # align the stack - needed in 64 bit asm
    and $-16, %rsp

    # we don't need to push them to stack
    leaq numberloved(%rip), %rcx
    # use value, not the address
    movq (%rcx), %rcx
    
    leaq  personstring(%rip), %rdx
    leaq  name(%rip), %rsi
    leaq  firststring(%rip), %rdi
    
    callq _printf

    # exit program
    movq $0, %rdi
    callq _exit
