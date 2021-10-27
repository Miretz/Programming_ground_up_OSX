#PURPOSE:  This program finds the maximum number of a
#          set of data items.
#

#VARIABLES: The registers have the following uses
#
# %rdi - Address of data item being checked
# %ebx - Largest data item found
# %eax - Current data item
# %ecx - Item counter
#
# The following memory locations are used:
#
# data_itesm - contains the item data.
# length - the loop terminates after processing
#          this number of items
#

.section __DATA,__data

data_items:
    .long 3,67,34,0,45,75,54,34,44,33,22,11,66,0
length:
    .long 5

.section __TEXT,__text


.globl _main
_main:

    leaq data_items(%rip), %rdi     # move the address of data_items into %rdi 
    movq (%rdi), %rax               # load the first item of data
    movl %eax, %ebx                 # %eax now contains the largest number
    movl $1, %ecx                   # setup the counter

start_loop:
    cmpl length(%rip), %ecx         # compare number of items with length
    je loop_exit
    incl %ecx                       # increment the counter
    add $4, %rdi                    # increment the adress in %rdi
    movq (%rdi), %rax               # load the next value into %rax
    cmpl %ebx, %eax                 
    jle start_loop                  # if smaller jump to start
    movl %eax, %ebx                 # move the largest value into ebx
    jmp start_loop                  # loop
     
loop_exit:
    # exit program
    movl $0x2000001,%eax
    movq %rbx, %rdi                 # set the largest number as exit status
    syscall
