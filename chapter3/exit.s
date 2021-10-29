#PURPOSE:    Simple program that exits and returns a
#            status code back to the Linux kernel

#INPUT:      none
#

#OUTPUT:     returns a status code. This can be viewed
#            by typing
#
#            echo $?
#
#            after running the program

#VARIABLES:  
#            %eax holds the system call number
#            %edi holds the return status
#

.section __TEXT,__text
.globl _main
_main:
    movl $0x2000001,%eax
                  # this is the MacOS kernel command
                  # number (system call) for exiting
                  # a program

    movl $42, %edi   
                  # this is the status number we will
                  # return to the operating system.
                  # Change this around and it will
                  # return different things to
                  # echo $?

    syscall       # this wakes up the kernel to run
                  # the exit command
