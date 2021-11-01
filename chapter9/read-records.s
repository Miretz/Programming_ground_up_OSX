.include "../chapter6/osx.s"
.include "../chapter6/record-def.s"

.section __DATA,__data

format: .asciz "Name: %s, Age: %d, works as an %s.\n"
record_buffer_ptr: .quad 0

.section __TEXT,__text

.equ ST_ARGV_1, 32    # input file name

.globl _main
_main:
    .equ ST_INPUT_DESC, -8

    dec %rdi         # check number of arguments
    cmpq $1, %rdi    # we need exaclty 1 argument
    jne error        # wrong number of args

    movq %rsp, %rbp
    subq $8, %rsp

    # initialize allocator
    call allocate_init
    
    movq $SYS_OPEN, %rax       # open the file
    movq ST_ARGV_1(%rbp), %rdi # read filename
    movq $0x00000000, %rsi     # O_RDONLY
    movq $0666, %rdx           # mode
    syscall

    # save the input file descriptor
    movq %rax, ST_INPUT_DESC(%rbp)

    # allocate memory
    subq $8, %rsp
    pushq $500 # buffer size
    call allocate
    leaq record_buffer_ptr(%rip), %rdi
    movq %rax, (%rdi)

record_read_loop:
    # read record from file
    pushq ST_INPUT_DESC(%rbp)
    leaq record_buffer_ptr(%rip), %rdx
    pushq %rdx # location of the buffer
    call read_record
    addq $16, %rsp

    # returns the number of bytes read
    cmpq $RECORD_SIZE, %rax
    jne  finished_reading

print_record:
    # otherwise, print the first name and age
    # parameter name
    leaq record_buffer_ptr(%rip), %rsi
    addq $RECORD_FIRSTNAME, %rsi
    
    # parameter age
    leaq record_buffer_ptr(%rip), %rdx
    addq $RECORD_AGE, %rdx
    movq (%rdx), %rdx
        
    # parameter position
    leaq record_buffer_ptr(%rip), %rcx
    addq $RECORD_POSITION, %rcx
    
    # string format
    leaq format(%rip), %rdi

    # call printf
    movq $1, %rax
    callq _printf

    jmp record_read_loop

finished_reading:
    subq $8, %rsp
    leaq record_buffer_ptr(%rip), %rdx
    pushq %rdx
    call deallocate

    movq $SYS_EXIT, %rax     # exit program
    movl $0, %edi
    syscall

error:
    movq $SYS_EXIT, %rax
    movl $1, %edi
    syscall
