.include "osx.s"
.include "record-def.s"

.section __DATA,__data

.section __BSS,__bss
.lcomm record_buffer, RECORD_SIZE

.section __TEXT,__text

format:
    .asciz "%40s"

num_format:
    .asciz "%d"

file_name:
    .asciz "test.dat"

.equ ST_FILE_DESC, -8

.globl _main
_main:
    movq %rsp, %rbp      # copy stack pointer to %rbp
    subq $8, %rsp        # allocate space to hold the
                         # file descriptor
    
    # open the file for writing / append
    movq $SYS_OPEN, %rax
    leaq file_name(%rip), %rdi
    movq $0x00000009, %rsi
    movq $0666, %rdx
    syscall

    # store the file descriptor
    movq %rax, ST_FILE_DESC(%rbp)

    # seek to the end
    movq ST_FILE_DESC(%rbp), %rdi   # file descriptor for lseek
    movq $0, %rsi                   # offset for writing
    movq $2, %rdx                   # SEEK_END flag
    callq _lseek

    # read firstname
    leaq format(%rip), %rdi
    leaq record_buffer(%rip), %rsi
    movq $0, %rax
    callq _scanf
    callq _getchar

    # read lastname
    leaq format(%rip), %rdi
    leaq record_buffer(%rip), %rsi
    addq $RECORD_LASTNAME, %rsi
    movq $0, %rax
    callq _scanf
    callq _getchar

    # read address
    leaq format(%rip), %rdi
    leaq record_buffer(%rip), %rsi
    addq $RECORD_ADDRESS, %rsi
    movq $0, %rax
    callq _scanf
    callq _getchar

    # read age
    leaq num_format(%rip), %rdi
    leaq record_buffer(%rip), %rsi
    addq $RECORD_AGE, %rsi
    movq $0, %rax
    callq _scanf
    callq _getchar

    # read position
    leaq format(%rip), %rdi
    leaq record_buffer(%rip), %rsi
    addq $RECORD_POSITION, %rsi
    movq $0, %rax
    callq _scanf
    callq _getchar

    # write the record    
    pushq ST_FILE_DESC(%rbp)
    leaq record_buffer(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

end_loop:
    # close the file descriptor
    movq $SYS_CLOSE, %rax
    movq ST_FILE_DESC(%rbp), %rdi
    syscall

    # exit the program
    movq $SYS_EXIT, %rax
    movl $0, %edi
    syscall

