.include "../chapter6/record-def.s"
.include "../chapter6/osx.s"

#PURPOSE: This function reads a record from the
#         file descriptor
#
#INPUT:   The file descriptor and a buffer
#
#OUTPUT:  This function writes the data to the
#         buffer and returns a status code.

# STACK LOCAL VARIABLES

.equ ST_READ_BUFFER, 16
.equ ST_FILEDES, 24

.section __TEXT,__text

.globl read_record
read_record:
    pushq %rbp
    movq  %rsp, %rbp
    pushq %rbx

    movq  $SYS_READ, %rax
    movq  ST_FILEDES(%rbp), %rdi
    movq  ST_READ_BUFFER(%rbp), %rsi
    movq  $RECORD_SIZE, %rdx
    syscall

    popq %rbx
    movq %rbp, %rsp
    popq %rbp
    ret
