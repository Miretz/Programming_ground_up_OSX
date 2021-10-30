#PURPOSE: This program increments each person's age by one
#         and writes back to the source file.

.include "osx.s"
.include "record-def.s"

.section __DATA,__data
input_file_name: .asciz "test.dat"

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

# stack offsets of local variables
.equ ST_INPUT_DESC, -8

.section __TEXT,__text

.globl _main
_main:
    movq %rsp, %rbp     # copy stack pointer
    subq $8, %rsp      # allocate space for
                        # local variables
    
    # open the file for reading
    movq $SYS_OPEN, %rax
    leaq input_file_name(%rip), %rdi
    movq $0x00000002, %rsi     # read & write
    movq $0666, %rdx
    syscall

    # save the input file descriptor
    movq %rax, ST_INPUT_DESC(%rbp)

    # record counter
    movq $0, %rbx

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
    incq (%rdi)
    
    # seek position to write
    movq ST_INPUT_DESC(%rbp), %rdi   # file descriptor for lseek
    movq $RECORD_SIZE, %rsi          # offset for writing
    imulq %rbx, %rsi                 # multiply by record count
    movq $0, %rdx                    # SEEK_START flag    
    callq _lseek

    # write the record out
    pushq ST_INPUT_DESC(%rbp)
    leaq record_buffer(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

    incq %rbx

    jmp loop_begin

loop_end:
    
    # close the file descriptor
    movq $SYS_CLOSE, %rax
    movq ST_INPUT_DESC(%rbp), %rdi
    syscall

    # exit the program
    movq $SYS_EXIT, %rax
    movl $0, %edi
    syscall

