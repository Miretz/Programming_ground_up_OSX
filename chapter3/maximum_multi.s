#PURPOSE:  This program finds the maximum number of
#          three lists of data items.
#

#VARIABLES: The registers have the following uses
#
# %rdi - Address of data item being checked
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
#              to terminate the data 

.section __DATA,__data
data_items1: .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
data_items2: .long 9,3,2,1,4,2,3,4,2,3,4,3,4,56,3,2,3,2,1,0
data_items3: .long 1,1,1,1,1,1,1,1,1,1,1,1,5,1,1,1,1,1,1,0
.section __TEXT,__text


.globl _main
_main:
    leaq data_items1(%rip), %rdi     # move the address of data_items1 into %rdi
    pushq %rdi                       # push the list address onto stack
    call maximum                     # call maximum function

    leaq data_items2(%rip), %rdi     # move the address of data_items2 into %rdi
    pushq %rdi
    call maximum

    leaq data_items3(%rip), %rdi     # move the address of data_items3 into %rdi
    pushq %rdi
    call maximum

    movl $0x2000001,%eax  # exit program
    movq %rbx, %rdi       # set the largest number as exit status
    syscall

maximum:
    pushq %rbp            # save old base pointer
    movq  %rsp, %rbp      # make stack pointer the base pointer
    subq  $8, %rsp        # get room for our local storage
    movq  16(%rbp), %rdi  # put first argument into %rbx
    movq  (%rdi), %rax    # load the first item of data
    movl  %eax, %ebx      # %eax now contains the largest number

start_loop:
    cmpl $0, %eax         # check to see if we've hit 0
    je loop_exit
    add $4, %rdi          # increment the adress in %rdi
    movq (%rdi), %rax     # load the next value into %rax
    cmpl %ebx, %eax
    jle start_loop        # if smaller jump to start
    movl %eax, %ebx       # move the largest value into ebx
    jmp start_loop        # loop

loop_exit:
    movq %rbx, %rax     # put the result in %rax
    movq %rbp, %rsp     # restore the stack pointer
    popq %rbp           # restore the base pointer
    ret
