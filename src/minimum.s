.section .data

data_items:
.long 3, 5, 123, 298, 78, 2, 98, 0

.section .text

.globl _start
_start:
	movl $0, %edi
	movl data_items(,%edi, 4), %eax
	movl %eax, %ebx
	cmpl $0, %eax
	je loop_exit

start_loop:
	incl %edi
	movl data_items(, %edi, 4), %eax
	cmpl $0, %eax
	je loop_exit
	cmpl %eax, %ebx
	jle start_loop
	movl %eax, %ebx
	jmp start_loop

loop_exit:
	movl $1, %eax
	int $0x80
