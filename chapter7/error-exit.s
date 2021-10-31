.include "osx.s"

.equ ST_ERROR_CODE, 16
.equ ST_ERROR_MSG, 24

.globl error_exit

error_exit:
    pushq %rbp
    movq  %rsp, %rbp

    # write out the error code
    movq  ST_ERROR_CODE(%rbp), %rsi
    pushq %rsi
    call  count_chars
    popq  %rsi
    movq  %rax, %rdx
    movq  $STDERR, %rdi
    movq  $SYS_WRITE, %rax
    syscall

    # write out the error message
    movq  ST_ERROR_MSG(%rbp), %rsi
    pushq %rsi
    call  count_chars
    popq  %rsi
    movq  %rax, %rdx
    movq  $STDERR, %rdi
    movq  $SYS_WRITE, %rax
    syscall

    pushq $STDERR
    call  write_newline

    # exit with status 1
    movq $SYS_EXIT, %rax
    movl $1, %edi
    syscall
