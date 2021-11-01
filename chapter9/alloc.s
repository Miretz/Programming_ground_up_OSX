#PURPOSE: Program to manage memory usage - allocate
#         and deallocate memory as requested

#NOTES:   The programs using these routines will ask
#         for a certain size of memory.  We actually
#         use more than that size, but we put it
#         at the beginning, before the pointer
#         we hand back.  We add a size field and
#         an AVAILABLE/UNAVAILABLE marker.  So, the
#         memory looks like this
#
# #########################################################
# #Available Marker#Size of memory#Actual memory locations#
# #########################################################
#                                  ^--Returned pointer
#                                     points here

.section __DATA,__data

# global variables
heap_begin: 
    .quad 0

current_break: 
    .quad 0

# structure information
.equ HEADER_SIZE, 16
.equ HDR_AVAIL_OFFSET, 0   # location of the available flag
.equ HDR_SIZE_OFFSET, 8    # location of the size field

# constants
.equ UNAVAILABLE, 0        # mark space that has been given out
.equ AVAILABLE, 1          # mark space that has been returned
.equ SYS_BRK, 0x2000069    # system call number for break

.section __TEXT,__text

# functions
.globl allocate_init
allocate_init:
    pushq %rbp
    movq  %rsp, %rbp

    # sbrk call with 0 in %rbx returns last
    # valid usable address
    movq $0, %rdi
    callq _sbrk

    incq %rax               # %rax has the last valid address
                            # and we want the location after that
    leaq current_break(%rip), %rdi  # store the current break
    movq %rax, (%rdi)
    leaq heap_begin(%rip), %rdi
    movq %rax, (%rdi)

    movq %rbp, %rsp
    popq %rbp
    ret

.globl allocate

.equ ST_MEM_SIZE, 16         # stack position of the memory to allocate

allocate:
    pushq %rbp
    movq  %rsp, %rbp

    movq ST_MEM_SIZE(%rbp), %rcx  # read the the function parameter (memsize)
    
    movq heap_begin(%rip), %rax   # %rax holds first search location
    movq current_break(%rip), %rbx # %rbx holds the current break

alloc_loop_begin:           # iterate memory regions
    cmpq %rax, %rbx         # need more memory if these are equal
    je move_break

    movq HDR_SIZE_OFFSET(%rax), %rdx  # grab the size of this memory
    cmpq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax) # check if available
    je   next_location                # is not, go to the next one

    cmpq %rdx, %rcx         # space is available, compare the size
    jle allocate_here       # it's big enough, go to allocate_here

next_location:
    addq $HEADER_SIZE, %rax # the total size of the memory
    addq %rdx, %rax         # is the sum requested and our header
    jmp alloc_loop_begin    # go look at the next location
    
allocate_here:
    movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax) # mark as unavailable
    addq $HEADER_SIZE, %rax # move %eax past the header to the usable memory

    movq %rbp, %rsp
    popq %rbp
    ret

move_break: # exhausted all addressable memory, ask kernel for more
    addq $HEADER_SIZE, %rbx   # space for header
    addq %rcx, %rbx           # space for break

    pushq %rax                # save registers
    pushq %rcx
    pushq %rbx

    movq %rcx, %rdi
    addq $HEADER_SIZE, %rdi
    callq _sbrk

    cmpq $0, %rax             # check for errors
    je error

    popq %rbx                 # restore saved registers
    popq %rcx
    popq %rax
    
    movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax) # set unavailable
    movq %rcx, HDR_SIZE_OFFSET(%rax)          # set size
    addq $HEADER_SIZE, %rax                   # move %eax to the actual
                                              # start of usable memory
    movq %rbx,  current_break(%rip)
    
    movq %rbp, %rsp
    popq %rbp
    ret

error:
    movq $0, %rax      # on error, return 0
    movq %rbp, %rsp
    popq %rbp
    ret

.globl deallocate
deallocate:
    movq 8(%rsp), %rax
    subq $HEADER_SIZE, %rax        # get to the real beginning of the memory
    movq $AVAILABLE, HDR_AVAIL_OFFSET(%rax) # mark it available
    ret                             # that's it


