.include "osx.s"
.include "record-def.s"

.section __DATA,__data

record1:
    .ascii "Fredrick\0"
    .rept 31 # Padding
    .byte 0
    .endr

    .ascii "Bartlett\0"
    .rept 31
    .byte 0
    .endr

    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209
    .byte 0
    .endr

    .long 45

record2:
    .ascii "Marilyn\0"
    .rept 32
    .byte 0
    .endr

    .ascii "Taylor\0"
    .rept 33
    .byte 0
    .endr

    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203
    .byte 0
    .endr

    .long 29

record3:
    .ascii "Derrick\0"
    .rept 32
    .byte 0
    .endr

    .ascii "McIntire\0"
    .rept 31
    .byte 0
    .endr

    .ascii "500 W Oakland\nSan Diego, CA 54321\0"
    .rept 206
    .byte 0
    .endr
    
    .long 36

.section __TEXT,__text

file_name:
    .asciz "test.dat"

.equ ST_FILE_DESCRIPTOR, -8

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

    # write first record
    pushq ST_FILE_DESCRIPTOR(%rbp)
    leaq record1(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

    # write second record
    pushq ST_FILE_DESCRIPTOR(%rbp)
    leaq record2(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

    # write third record
    pushq ST_FILE_DESCRIPTOR(%rbp)
    leaq record3(%rip), %rdi
    pushq %rdi
    call write_record
    addq $16, %rsp

    # close the file descriptor
    movq $SYS_CLOSE, %rax
    movq ST_FILE_DESCRIPTOR(%rbp), %rdi
    syscall

    # exit the program
    movq $SYS_EXIT, %rax
    movq $0, %rbx
    syscall

