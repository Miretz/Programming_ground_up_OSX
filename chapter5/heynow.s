#PURPOSE:   This program creates a file called heynow.txt
#           with the text "Hey diddle diddle!"
#

.section __DATA,__data
.section __TEXT,__text

path:
    .asciz "heynow.txt"
content:
    .asciz "Hey diddle diddle!\n"
    content_len = . - content

# system call numbers
.equ SYS_OPEN, 0x2000005
.equ SYS_WRITE, 0x2000004
.equ SYS_READ, 0x2000003
.equ SYS_CLOSE, 0x2000006
.equ SYS_EXIT, 0x2000001

# file flags
.equ O_RDONLY, 0x00000000
.equ O_CREAT_WRONLY_TRUNC, 0x00000601

.globl _main
_main:
open:
    movq $SYS_OPEN, %rax       # open syscall
    leaq path(%rip), %rdi # address of file path
    movq $O_CREAT_WRONLY_TRUNC, %rsi # file flags
    movq $0666, %rdx           # file permissions
    syscall                    # call the kernel

write:
    movq %rax, %rdi            # store the file descriptor
    movq $SYS_WRITE, %rax      # write to the out file
    leaq content(%rip), %rsi   # out buffer
    movq $content_len, %rdx    # length of output
    syscall

close:
    movq $SYS_CLOSE, %rax      # close out file
    syscall                    # %rdi still has the
                               # file descriptor
exit:
    movl $SYS_EXIT, %eax       # exit program
    movl $0, %ebx
    syscall
   
