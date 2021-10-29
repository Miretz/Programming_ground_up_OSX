.include "osx.s"
.include "record-def.s"

.section __DATA,__data

record1:
    .asciz "Fredrick"
    .rept 31 # Padding
    .byte 0
    .endr

    .asciz "Bartlett"
    .rept 31
    .byte 0
    .endr

    .asciz "4242 S Prairie\nTulsa, OK 55555"
    .rept 209
    .byte 0
    .endr

    .long 45

record2:
    .asciz "Marilyn"
    .rept 32
    .byte 0
    .endr

    .asciz "Taylor"
    .rept 33
    .byte 0
    .endr

    .asciz "2224 S Johannan St\nChicago, IL 12345"
    .rept 203
    .byte 0
    .endr

    .long 29

record3:
    .asciz "Derrick"
    .rept 32
    .byte 0
    .endr

    .asciz "McIntire"
    .rept 31
    .byte 0
    .endr

    .asciz "500 W Oakland\nSan Diego, CA 54321"
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

