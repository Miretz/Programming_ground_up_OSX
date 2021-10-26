#PURPOSE:  This program finds the minimum number of a
#          set of data items.
#

#VARIABLES: The registers have the following uses
#
# %rdi - Address of data item being checked
# %ebx - Smallest data item found
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

    leaq data_items(%rip), %rdi     # move the address of data_items into %rdi 
    movq (%rdi), %rax               # load the first item of data
    movl %eax, %ebx                 # %eax now contains the first number

start_loop:
    add $4, %rdi                    # increment the adress in %rdi
    movq (%rdi), %rax               # load the next value into %rax
    cmpl %ebx, %eax                 
    jge start_loop                  # if it's larger jump to start
    cmpl $0, %eax                   # check to see if we've hit 0
    je loop_exit
    movl %eax, %ebx                 # move the smallest value into ebx
    jmp start_loop                  # loop
     
loop_exit:
    # exit program
    movl $0x2000001,%eax
    movq %rbx, %rdi                 # set the smallest number as exit status
    syscall
