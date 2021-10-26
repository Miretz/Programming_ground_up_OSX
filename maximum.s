#PURPOSE:  This program finds the maximum number of a
#          set of data items.
#

#VARIABLES: The registers have the following uses
#
# %rdi - Address of data item being checked
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_itesm - contains the item data. A 0 is used
#              to terminate the data 

.section __DATA,__data

data_items:
    .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section __TEXT,__text


.globl _main
_main:

    leaq data_items(%rip), %rdi     # move 0 into the index register 
    movq (%rdi), %rax
                                    # load the first byte of data

    movl %eax, %ebx                 # eax is the biggest number

start_loop:
    cmpl $0, %eax                   # check to see if we've hit 0
    je loop_exit
    add $4, %rdi                    # load next value
    movq (%rdi), %rax
    cmpl %ebx, %eax
    jle start_loop                  # if smaller jump to start
    movl %eax, %ebx                 # move the largest value into ebx
    jmp start_loop                  # loop
     
loop_exit:
    # exit program
    movl $0x2000001,%eax
    movq %rbx, %rdi                 # set the largest number as exit
    syscall
