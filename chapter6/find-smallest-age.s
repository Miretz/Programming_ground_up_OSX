#PURPOSE: Create a program to find the smallest age in the file 
#         and return that age as the status code of the program.

.include "osx.s"
.include "record-def.s"

.section __DATA,__data

file_name: .asciz "test.dat"

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

.section __TEXT,__text

.globl _main
_main:
    .equ ST_INPUT_DESCRIPTOR, -8

    movq %rsp, %rbp
    subq $8, %rsp

    movq $SYS_OPEN, %rax       # open the file
    leaq file_name(%rip), %rdi # read filename
    movq $0x00000000, %rsi     # O_RDONLY
    movq $0666, %rdx           # mode
    syscall

    # save the input file descriptor
    movq %rax, ST_INPUT_DESCRIPTOR(%rbp)

    # save the maximum value
    movl $99, %ebx

record_read_loop:
    pushq ST_INPUT_DESCRIPTOR(%rbp)
    
    leaq  record_buffer(%rip), %rdi # get buffer address
    pushq %rdi                      # location of the buffer
    call read_record
    addq $16, %rsp

    # returns the number of bytes read
    cmpq $RECORD_SIZE, %rax
    jne  finished_reading

get_age:
    # get the age value
    leaq record_buffer(%rip), %rdi
    addq $RECORD_AGE, %rdi
    movq (%rdi), %rdi

    # check if the age is smaller
    cmpl %edi, %ebx
    jle record_read_loop

    # it's greater, store the value into %rbx
    movl %edi, %ebx

    jmp record_read_loop

finished_reading:
    movq $SYS_EXIT, %rax     # exit program
    movl %ebx, %edi          # put the largest value
    syscall                  # as the status code

