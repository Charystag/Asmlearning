
# %eax will be used to store the number we're looking at
# %ebx will be used to store our maximum
# %ecx will be used to store our end address
# %edx will be used to store the numbers of items we have to create our end address and then 
# will be used to store our current address
# %edi wiil be used to store our index
.section .data

items_number:
	.long	14
data_items:
	.long	0, 13, 31, 41, 52, 23, 41, 52, 23, 95, 18, 201, 123, 212

.section .text
.globl _start
_start:
	cmpl $1, items_number 	# We compare 1 with the items_number to ensure
								# that we have at least 1 items in the list
	jle err_start
	movl items_number, %edx
	leal data_items(,%edx,4), %ecx	# We move the address within data_items + items_number into %ecx
	leal data_items, %edx
	movl (%edx), %ebx
	jmp start_loop

err_start:
	movl $-1, %ebx
	jmp end_loop

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
