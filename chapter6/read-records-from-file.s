.include "osx.s"
.include "record-def.s"

.section __DATA,__data

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

.section __TEXT,__text

.equ ST_ARGV_1, 8    # input file name

.globl _main
_main:
    .equ ST_INPUT_DESCRIPTOR, -8
    .equ ST_OUTPUT_DESCRIPTOR, -16

    movq %rsp, %rbp
    subq $16, %rsp

    dec %rdi         # check number of arguments
    cmpq $1, %rdi    # we need exaclty 1 argument
    jne error        # wrong number of args
   
    movq $SYS_OPEN, %rax       # open the file
    movq ST_ARGV_1(%rsi), %rdi # read filename
    movq $0x00000000, %rsi     # O_RDONLY
    movq $0666, %rdx           # mode
    syscall

    # save the input file descriptor
    movq %rax, ST_INPUT_DESCRIPTOR(%rbp)

    # save the output file descriptor
    movq $STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)

record_read_loop:
    pushq ST_INPUT_DESCRIPTOR(%rbp)
    
    leaq  record_buffer(%rip), %rdi # get buffer address
    pushq %rdi                      # location of the buffer
    call read_record
    addq $16, %rsp

    # returns the number of bytes read
    cmpq $RECORD_SIZE, %rax
    jne  finished_reading

    # otherwise, print the first name
    # but first we must know the size
    leaq record_buffer(%rip), %rdi
    addq $RECORD_FIRSTNAME, %rdi
    pushq %rdi
    call count_chars
    addq $8, %rsp

    movq %rax, %rdx
    movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
    movq $SYS_WRITE, %rax
    leaq record_buffer(%rip), %rsi
    addq $RECORD_FIRSTNAME, %rsi
    syscall

    pushq ST_OUTPUT_DESCRIPTOR(%rbp)
    call write_newline
    addq $8, %rsp

    jmp record_read_loop

finished_reading:
    movq $SYS_EXIT, %rax     # exit program
    movl $0, %edi
    syscall

error:
    movq $SYS_EXIT, %rax
    movl $1, %edi
    syscall
