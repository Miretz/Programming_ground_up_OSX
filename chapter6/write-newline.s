.include "osx.s"

.globl write_newline

.section __DATA,__data
newline: .ascii "\n"
.section __TEXT,__text

.equ ST_FILEDES, 16

write_newline:
    pushq %rbp
    movq  %rsp, %rbp

    movq $SYS_WRITE, %rax
    movq ST_FILEDES(%rbp), %rdi
    leaq newline(%rip), %rsi
    movq $1, %rdx
    syscall

    movq %rbp, %rsp
    popq %rbp
    ret
    
