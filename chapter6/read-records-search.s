#PURPOSE: This program allows the user to enter 5 characters, and it 
#         return all records whose first name starts with those 5 characters.

.include "osx.s"
.include "record-def.s"

.section __DATA,__data

file_name: .asciz "test.dat"

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

.section __TEXT,__text

.equ ST_ARGV_1, 8 # search string

.globl _main
_main:
    .equ ST_INPUT_DESCRIPTOR, -8
    .equ ST_OUTPUT_DESCRIPTOR, -16
    .equ ST_SEARCH, -24

    movq %rsp, %rbp
    subq $24, %rsp

    # save the search string
    movq ST_ARGV_1(%rsi), %rax 
    movq %rax, ST_SEARCH(%rbp)
    
    movq $SYS_OPEN, %rax       # open the file
    leaq file_name(%rip), %rdi # read filename
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

    # compare firstname with the user input
    pushq ST_SEARCH(%rbp)           # location of the search string
    leaq  record_buffer(%rip), %rsi # get buffer address
    pushq %rsi                      # location of the buffer
    call compare_strings
    addq $16, %rsp

    # read next record if the strings don't match
    cmpl $1, %eax
    jne record_read_loop

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
    movq $0, %rbx
    syscall

