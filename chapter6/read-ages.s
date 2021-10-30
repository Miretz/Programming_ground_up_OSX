.include "osx.s"
.include "record-def.s"

.section __DATA,__data

format: .asciz "Name: %s, Age: %d, works as an %s.\n"

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

.section __TEXT,__text

.equ ST_ARGV_1, 8    # input file name

.globl _main
_main:
    .equ ST_INPUT_DESC, -8

    dec %rdi         # check number of arguments
    cmpq $1, %rdi    # we need exaclty 1 argument
    jne error        # wrong number of args

    movq %rsp, %rbp
    subq $8, %rsp

    movq $SYS_OPEN, %rax       # open the file
    movq ST_ARGV_1(%rsi), %rdi # read filename
    movq $0x00000000, %rsi     # O_RDONLY
    movq $0666, %rdx           # mode
    syscall

    # save the input file descriptor
    movq %rax, ST_INPUT_DESC(%rbp)

record_read_loop:
    pushq ST_INPUT_DESC(%rbp)
    leaq  record_buffer(%rip), %rdi # get buffer address
    pushq %rdi                      # location of the buffer
    call read_record
    addq $16, %rsp

    # returns the number of bytes read
    cmpq $RECORD_SIZE, %rax
    jne  finished_reading

    # otherwise, print the first name and age
    # parameter name
    leaq record_buffer(%rip), %rsi
    addq $RECORD_FIRSTNAME, %rsi
    
    # parameter age
    leaq record_buffer(%rip), %rdx
    addq $RECORD_AGE, %rdx
    movq (%rdx), %rdx
        
    # parameter position
    leaq record_buffer(%rip), %rcx
    addq $RECORD_POSITION, %rcx
    
    # string format
    leaq format(%rip), %rdi

    # call printf
    movq $1, %rax
    callq _printf

    jmp record_read_loop

finished_reading:
    movq $SYS_EXIT, %rax     # exit program
    movl $0, %edi
    syscall

error:
    movq $SYS_EXIT, %rax
    movl $1, %edi
    syscall
