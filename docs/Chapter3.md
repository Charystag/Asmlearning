# Chapter 3 | Your First Programs

During this Chapter, we might need to refer to Appendix B *(See page 199)* and Appendix F 
*(See page 223)*.

## First Program

The first program is **exit.s**, which will just returns a value (that we can echo after 
with `echo $?`). See [here](/src/exit.s) for the source code.

-	**Source code** : Human-readable form of a program. 

-	**Assembling** : Transforming the program into instructions for the machine. It transforms the 
human-readable file into a machine-readable one.

To assembly the program we type : 
```bash
as exit.s -o exit.o
```

[as](https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_node/as_toc.html) runs the assembler, 
`exit.s` is the source file and `exit.o` is the resulting **object file**.

-	**Object File** : Code that is in the machine's language, but hasn't completely been put 
together.

The **linker** puts the object files together and adds information so that the kernel know how to 
load and run it. In our case, there is only one object file so the linker adds info to enable it 
to run.

To link the object file, we run the following command :
```bash
ld exit.o -o exit
```
[ld](https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_chapter/ld_toc.html) runs the linker, 
`exit.o` is the object file we want to link and `exit` is our newly created program.

After that we can run the exit program by typing `./exit` and view the status code by typing 
`echo $?`.

## Outline of an Assembly Language program

### Comments

What to include into comments :
-	The purpose of the code
-	An overview of the processing involved
-	Anything strange the program does and why it does it *Design the program and writes the comments 
always having future programmers in mind*

### Assembler directives/Pseudo operations

After the comments, the first section says :
```assembly
.section .data
```

Anything starting with a period isn't directly translated into a machine instruction, it is an 
instruction to the assembler itself. They are handled by the assembler and not run by the computer.

The command `.section` breaks the program up into sections.

-	The **data** section is where any memory storage needed for data is listed. Our program doesn't 
use any but this section is listed for completeness. Almost every program needs a data section.
-	The **text** section is where the program instructions live.

The next instruction is :
```assembly
.globl _start
```
This instructs the assembler that `_start` is an important **symbol** to remember.

-	A symbol is going to be replaced by something else during assembly or linking. They are 
generally used to mark locations of programs or data, to refer them by name instead of location 
number.

`.globl` tells the assembler that the symbol will be needed by the linker. `_start` should always 
be marked with `.globl`. Otherwise, when the program is loaded into memory, the computer won't 
know where it starts.

The next line 
```assembly
_start:
```
defines the value of the `_start` label.

- **Label** : Symbol followed by a column. It defines a symbol's value.

### Instructions

The first instruction is :
```assembly
movl $1, %eax
```
it transfers the number 1 into the %eax register. In assembly, many instructions have *operands*. 
*movl* has two : *source* and *destination*. In this case, source is the literal number 1 and 
destination is the `%eax` register.

On most instructions that have two operands, the first is the source and the second is the 
destination. In these case, the source isn't modified (ex : `addl`, `subl` and `imull`). Other 
instructions, like `idivl` may have an operand hardcoded in.

The `idivl` instruction requres the dividend to be in `%eax` and `%edx` to be zero. The quotient 
will be transferred to `%eax`, the remainder to `%edx`. However the divisor can be any register or 
memory location.

On x86 processors, there are several general-purpose registers :

-	`%eax`
-	`%ebx`
-	`%ecx`
-	`%edx`
-	`%edi`
-	`%esi`

In addition to these, there are several special-purpose registers, including :

-	`%ebp`
-	`%esp`
-	`%eip`
-	`%eflags`

the movl instruction moves the number 1 into `%eax`. The `$` in front of the 1 indicates that we 
want to use immediate mode addressing. Without the `$`, it would do direct addressing.

We move 1 into `%eax` is that because we prepare to call the Linux kernel, `1` is the number of the 
exit system call. See Appendix C (*page 209*) for a more complete list of the important Linux 
System Calls.

The parameters are store in other registers. The *exit* syscall requires a status code to be loaded 
in `%ebx`. The value is returned to the system. This is what we do with the instruction :
```assembly
movl $0, %ebx
```

The os requires certain registers to be loaded in a certain way before making a system call. We will 
transfer control to the kernel with the following instruction :
```assembly
int $0x80
```
The `int` stands for *interrupt*. `0x80` is the interrupt number to use. An *interrupt* interrupts 
the normal program flow and transfers control of our program to Linux so that it will do a syscall.

Procedure for syscalls :
1.	Setting up the registers in a special way (the syscall number into `%eax` at least and then 
other informations depending upon the syscall we're trying to make)
2.	Issuing the instruction `int $0x80` to call the Linux Kernel and do the syscall.
