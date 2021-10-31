.include "osx.s"
.include "record-def.s"

#PURPOSE:  This function writes a record to
#          the given file descriptor
#
#INPUT:    The file descriptor and a buffer
#
#OUTPUT:   This function produces a status code

# STACK LOCAL VARIABLES

.equ ST_WRITE_BUFFER, 16
.equ ST_FILEDES, 24

.section __TEXT,__text

.globl write_record
write_record:
    pushq %rbp
    movq  %rsp, %rbp
    pushq %rbx

    movq  $SYS_WRITE, %rax
    movq  ST_FILEDES(%rbp), %rdi
    movq  ST_WRITE_BUFFER(%rbp), %rsi
    movq  $RECORD_SIZE, %rdx
    syscall

    popq %rbx
    movq %rbp, %rsp
    popq %rbp
    ret
