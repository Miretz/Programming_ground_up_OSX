.include "osx.s"
.include "record-def.s"

.section __DATA,__data

record:
    .ascii "Miroslav\0"
    .rept 31 # Padding
    .byte 0
    .endr

    .ascii "Fakename\0"
    .rept 31
    .byte 0
    .endr

    .ascii "Some street 123\nSome City, 123\0"
    .rept 209
    .byte 0
    .endr

    .long 35

    .ascii "Developer\0"
    .rept 30
    .byte 0
    .endr

.section __TEXT,__text

file_name:
    .asciz "test.dat"

.equ ST_FILE_DESCRIPTOR, -8
.equ RECORD_COUNT, 30

.globl _main
_main:
    movq %rsp, %rbp      # copy stack pointer to %rbp
    subq $8, %rsp        # allocate space to hold the
                         # file descriptor
    movq $SYS_OPEN, %rax # open the file
    leaq file_name(%rip), %rdi
    movq $0x00000601, %rsi
    movq $0666, %rdx
    syscall

    # store the file descriptor
    movq %rax, ST_FILE_DESCRIPTOR(%rbp)

    # rbx used as counter
    movq $0, %rbx

write_record_loop:
    pushq ST_FILE_DESCRIPTOR(%rbp)
    leaq record(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

    # increment the counter and check
    incq %rbx
    cmpq $RECORD_COUNT, %rbx
    jne write_record_loop

end_loop:
    # close the file descriptor
    movq $SYS_CLOSE, %rax
    movq ST_FILE_DESCRIPTOR(%rbp), %rdi
    syscall

    # exit the program
    movq $SYS_EXIT, %rax
    movq $0, %rbx
    syscall

