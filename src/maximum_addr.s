
# %eax will be used to store the number we're looking at
# %ebx will be used to store our maximum
# %ecx will be used to store our end address
# %edx will be used to store the numbers of items we have to create our end address and then 
# will be used to store our current address
# %edi wiil be used to store our index
.section .data

items_number:
	.long	10
data_items:
	.long	0, 13, 31, 41, 52, 23, 41, 52, 23, 95, 3189, 418, 123, 333

.section .text
.globl _start
_start:
	movl $-255, %ebx 	# Moving -255 to the register to have the minimum
						# status code in case of error
	cmpl $1, items_number(,4) 	# We compare 1 with the items_number to ensure
								# that we have at least 1 items in the list
	jle end_loop
	movl items_number(,4), %edx
	leal data_items(,%edx,4), %ecx	# We move the address within data_items + items_number into %ecx
	leal data_items(,4), %edx
	jmp start_loop

start_loop:
	cmpl %ecx, %edx
	je end_loop
	movl (%edx), %eax
	addl $4, %edx
	cmp %eax, %ebx
	jge start_loop

	movl %eax, %ebx
	jmp start_loop

end_loop:
	movl $1, %eax
	int $0x80
