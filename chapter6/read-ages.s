.include "osx.s"
.include "record-def.s"

.section __DATA,__data

file_name: .asciz "test.dat"
format: .asciz "Name: %s, Age: %d.\n"

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

.section __TEXT,__text

.globl _main
_main:
    .equ ST_INPUT_DESC, -8

    movq %rsp, %rbp
    subq $8, %rsp

    movq $SYS_OPEN, %rax       # open the file
    leaq file_name(%rip), %rdi # read filename
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
    leaq record_buffer(%rip), %rsi
    addq $RECORD_FIRSTNAME, %rsi
    
    leaq record_buffer(%rip), %rdx
    addq $RECORD_AGE, %rdx
    movq (%rdx), %rdx
    
    leaq format(%rip), %rdi
    xor  %rax, %rax
    callq _printf

    jmp record_read_loop

finished_reading:
    movq $SYS_EXIT, %rax     # exit program
    movq $0, %rbx
    syscall

