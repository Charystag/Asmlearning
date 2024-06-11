#PURPOSE:	This program find the maximum number of a
#			set of data items.

#VARIABLES:	The registers have the following uses:
#
#	%edi -	Holds the index of the data item being examined
#	%ebx -	Largest data item found
#	%eax -	Current data item
#
#	The following memory locations are used:
#
#	data_items -	Contains the item data. A 0 is used to
#					terminate the data

.section .data

data_items:			#These are the data items
.long	3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text

.globl _start
_start:
movl $0, %edi		# move 0 into the index register
movl data_items(, %edi, 4), %eax	# load the first byte of data
movl %eax, %ebx		# since this is the first item, %eax is
					# the biggest
cmpl $0, %eax		# first comparison as we don't need to start the 
					# loop if 0 is in eax
je loop_exit

start_loop:			# start loop
	incl %edi			# load next value
	movl data_items(, %edi, 4), %eax
	cmpl $0, %eax		# check to see if we've hit the end
	je loop_exit
	cmp %ebx, %eax		# compare values
	jle start_loop		# jump to loop beginning if the new one 
						# isn't bigger

	movl %eax, %ebx		# move the value as the largest
	jmp start_loop		# jump to loop beginning

loop_exit:
# %ebx is the status code for the exit system call
# and it already has the maximum number
	movl $1, %eax	# 1 is the exit() syscall number
	int $0x80
