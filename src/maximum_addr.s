
# %eax will be used to store the number we're looking at
# %ebx will be used to store our maximum
# %ecx will be used to store our end address
# %edx will be used to store the numbers of items we have to create our end address and then 
# will be used to store our current address
# %edi wiil be used to store our index
.section .data

items_number:
	10
data_items:
	0, 13, 31, 41, 52, 23, 41, 52, 23, 95, 3189, 418, 123, 333

.section .text
.globl _start:
_start:
	movl items_number(,,4), %edx
	leal data_items(,%edx,4), %ecx
