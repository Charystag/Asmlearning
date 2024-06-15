#Variables
# %eax will hold the value we're currently looking at
# %ebx will hold our maximum value
# %ecx will hold our index

.section .data

length:
	.long 10

data_items:
	.long 0, 2, 31, 43, 28, 94, -2, 31, 23, 41, 92, 13

.section .text

.globl _start
_start:
	cmpl $1, length
	jle err_start
	movl $0, %ecx
	movl data_items, %ebx
	movl data_items, %eax
	jmp start_loop

start_loop:
	cmpl %ecx, length
	je end_loop
	movl data_items(,%ecx, 4), %eax
	incl %ecx
	cmpl %eax, %ebx
	jge start_loop

	movl %eax, %ebx
	jmp start_loop

err_start:
	movl $-1, %ebx
	jmp end_loop

end_loop:
	movl $1, %eax
	int $0x80
