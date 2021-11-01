#PURPOSE:   This program converts an input file
#           to an output file with all letters
#           converted to uppercase.
#

.section __DATA,__data

mode_read: .asciz "r"
mode_write: .asciz "w+"

.equ END_OF_FILE, 0

.section __BSS,__bss

#Buffer - this is where the data is loaded into
#         from the data file and written from
#         into the output file. This should
#         never exceed 16,000 for various
#         reasons.
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section __TEXT,__text

# stack positions
.equ ST_SIZE_RESERVE, 32  # size to reserve
.equ ST_FD_IN, -16    # input file descriptor
.equ ST_FD_OUT, -24  # output file descriptor
.equ ST_ARGC, 16      # number of arguments
.equ ST_ARGV_0, 24    # name of the program
.equ ST_ARGV_1, 32    # input file name
.equ ST_ARGV_2, 40   # output file name

.globl _main
_main:
    movq %rsp, %rbp              # save stack pointer
    subq $ST_SIZE_RESERVE, %rsp  # allocate space for
                                 # file descriptors

    and $-16, %rsp               # align the stack

open_files:
open_fd_in:                         # open input file
    movq ST_ARGV_1(%rbp), %rdi      # read filename
    leaq mode_read(%rip), %rsi      # file mode
    callq _fopen                    # call C function
    addq $8, %rsp                   # realign stack

store_fd_in:
    movq %rax, ST_FD_IN(%rbp)       # store the input
                                    # file pointer

open_fd_out:                        # open output file
    movq ST_ARGV_2(%rbp), %rdi      # read filename
    leaq mode_write(%rip), %rsi     # file mode
    callq _fopen                    # call C function
    addq $8, %rsp

store_fd_out:
    movq %rax, ST_FD_OUT(%rbp)       # store the output
                                     # file pointer

read_loop_begin:
    leaq BUFFER_DATA(%rip), %rdi    # location to read to
    movq $1, %rsi                   # element size in bytes
    movq $BUFFER_SIZE, %rdx         # nmemb - number of members 
    movq ST_FD_IN(%rbp), %rcx       # load file filter
    callq _fread                    # read into buffer

    cmpq $END_OF_FILE, %rax         # exit if EOF
    jle end_loop                    # EOF or error
                                    # end the loop

continue_read_loop:
    leaq BUFFER_DATA(%rip), %rdi # get buffer address
    pushq %rdi             # location of the buffer
    pushq %rax             # size of the buffer
    call convert_to_upper  # call the conversion function
    popq %rax              # get the size back
    addq $8, %rsp          # restore %esp

    movq %rax, %rdx        # copy size for writing

    movq ST_FD_OUT(%rbp), %rcx      # out file descriptor
    leaq BUFFER_DATA(%rip), %rdi    # location to read from
    movq $1, %rsi                   # nmemb - number of members 
    callq _fwrite                   # write buffer into file

    jmp read_loop_begin  # continue the loop

end_loop:

    #NOTE - we don't need to do error checking
    #       on these, because error conditions
    #       don't signify anything special here

    # close out file
    movq ST_FD_OUT(%rbp), %rdi
    callq _fclose

    # close in file
    movq ST_FD_IN(%rbp), %rdi
    callq _fclose

    # exit program
    movq $0, %rdi
    callq _exit


#PURPOSE:   This function actually does the
#           conversion to upper case for a block
#
#INPUT:     The first parameter is the location
#           of the block of memory to convert
#           The second parameter is the length of
#            that buffer
#
#OUTPUT:    This function overwrites the current
#           buffer with the upper-casified version.
#
#VARIABLES:
#           %rax - beginning of buffer
#           %rbx - length of buffer
#           %rdi - current buffer offset
#           %cl - current byte being examined
#                 (first part of %ecx)
#

# the lower boundary of our search
.equ LOWERCASE_A, 'a'

# the upper boundary of our search
.equ LOWERCASE_Z, 'z'

# conversion between upper and lower case
.equ UPPER_CONVERSION, 'A' - 'a'

### STACK STUFF ###
.equ ST_BUFFER_LEN, 16    # length of the buffer
.equ ST_BUFFER, 24       # the buffer

convert_to_upper:
    pushq %rbp           # standard function stuff
    movq  %rsp, %rbp

    movq ST_BUFFER(%rbp), %rax  # character buffer
    movq ST_BUFFER_LEN(%rbp), %rbx  # length
    movq $0, %rdi                   # offset

    cmpq $0, %rbx        # if the lenght is zero
    je end_convert_loop  # exit the loop

convert_loop:
    movb (%rax, %rdi, 1), %cl  # current byte

    cmpb $LOWERCASE_A, %cl # check if the char
    jl next_byte           # is between a - z
    cmpb $LOWERCASE_Z, %cl # if yes, go to the
    jg next_byte           # next byte

    addb $UPPER_CONVERSION, %cl # convert byte
                                # to uppercase
    movb %cl, (%rax, %rdi, 1)   # store the value

next_byte:
    incq %rdi       # next byte
    cmpq %rdi, %rbx # continue unless
                    # we've reached the end
    jne convert_loop

end_convert_loop:
    # don't return value, just leave
    movq %rbp, %rsp
    popq %rbp
    ret
    
