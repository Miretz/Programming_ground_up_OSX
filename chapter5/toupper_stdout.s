#PURPOSE:   This program converts an STDIN input
#           to STDOUT output with all letters
#           converted to uppercase.
#
#PROCESSING: 1) While we're not at the end of the input
#               a) read part of STDIN into our memory buffer
#               b) go through each byte of memory
#                  when the byte is a lower-case letter,
#                  convert it to uppercase
#               c) write the output to STDOUT
#
#USAGE: $ echo "test me" | ./toupper_stdout.out
#       should print out "TEST ME"
#

.section __DATA,__data

# system call numbers
.equ SYS_OPEN, 0x2000005
.equ SYS_WRITE, 0x2000004
.equ SYS_READ, 0x2000003
.equ SYS_CLOSE, 0x2000006
.equ SYS_EXIT, 0x2000001

# options for open (look at /usr/include/asm/fcntl.h for
# various values. You can combine them by adding them or
# ORing them)
# On Mac you have to search for the header
# most likely in /Library/Developer/CommandLineTools/
.equ O_RDONLY, 0x00000000
.equ O_WRONLY, 0x00000001

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ END_OF_FILE, 0 # This is the return value of
                    # read which means we've hit
                    # the end of the file

.equ NUMBER_ARGUMENTS, 2

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
.equ ST_ARGC, 0      # number of arguments
.equ ST_ARGV_0, 0    # name of the program
.equ ST_ARGV_1, 8    # input file name
.equ ST_ARGV_2, 16   # output file name

.globl _main
_main:
    movq %rsp, %rbp           # save stack pointer
    
read_loop_begin:
    movq $SYS_READ, %rax            # read syscall
    movq $STDIN, %rdi                # load file desc
    leaq BUFFER_DATA(%rip), %rsi    # location to read
    movq $BUFFER_SIZE, %rdx         # size to read
    syscall                         # size returned in
                                    # %rax

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

    movq $SYS_WRITE, %rax  # write to the out file
    movq $STDOUT, %rdi  # out file descriptor
    leaq BUFFER_DATA(%rip), %rsi # out buffer
    syscall
    
    jmp read_loop_begin  # continue the loop

end_loop:
    movl $SYS_EXIT, %eax     # exit program
    movl $0, %ebx
    syscall


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
.equ ST_BUFFER_LEN, 16   # length of the buffer
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
    
