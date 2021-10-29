#PURPOSE: This program increments each person's age by one
#         and writes the new database into a new file.

.include "osx.s"
.include "record-def.s"

.section __DATA,__data
input_file_name: .asciz "test.dat"
output_file_name: .asciz "testout.dat"

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

# stack offsets of local variables
.equ ST_INPUT_DESC, -8
.equ ST_OUTPUT_DESC, -16

.section __TEXT,__text

.globl _main
_main:
    movq %rsp, %rbp     # copy stack pointer
    subq $16, %rsp      # allocate space for
                        # local variables
    
    # open the file for reading
    movq $SYS_OPEN, %rax
    leaq input_file_name(%rip), %rdi
    movq $0x00000000, %rsi     # O_RDONLY
    movq $0666, %rdx
    syscall

    # save the input file descriptor
    movq %rax, ST_INPUT_DESC(%rbp)

    # open file for writing
    movq $SYS_OPEN, %rax
    leaq output_file_name(%rip), %rdi
    movq $0x00000601, %rsi # O_CREAT | O_WRONLY | O_TRUNC
    movq $0666, %rdx
    syscall

    # save the output file descriptor
    movq %rax, ST_OUTPUT_DESC(%rbp)

loop_begin:
    pushq ST_INPUT_DESC(%rbp)
    leaq  record_buffer(%rip), %rdi # get buffer address
    pushq %rdi                      # location of the buffer
    call read_record
    addq $16, %rsp

    cmpq $RECORD_SIZE, %rax         # end-of-file or error
    jne loop_end

    # increment the age
    leaq record_buffer(%rip), %rdi
    addq $RECORD_AGE, %rdi
    incq %rdi
    
    # write the record out
    pushq ST_OUTPUT_DESC(%rbp)
    leaq record_buffer(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

    jmp loop_begin

loop_end:
    movq $SYS_EXIT, %rax     # exit program
    movq $0, %rbx
    syscall

