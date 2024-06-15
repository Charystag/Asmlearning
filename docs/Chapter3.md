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

## Planning the Program

In our next program we'll try to find the maximum of a list of numbers. We need to plan the 
following things to do so :

-	Where will the original list of numbers be stored?
-	What procedure will we need to follow to find the maximum number ?
-	How much storage do we need to carry out that procedure ?
-	Will all of the storage fit into registers, or do we need to use some memory as well?

Let's say that the address where the list of numbers starts is `data_items`. Let's say that the 
last number in the list will be a zero, so we know where to stop. We also need :
-	A value to hold the current position in the list (`%edi`)
-	A value to hold the current list element being examined (`%eax`)
-	A value to hold the current highest value in the list (`%ebx`)

When we begin the program and look at the first item of the list, we can set this value to be 
the current larget element of the list. The current position fo the list will be zero. From then 
we will follow the following steps :
1.	Check if the current list element (`%eax`) and see if it's zero
2.	If zero, exit
3.	Increase the current position (`%edi`)
4.	Load the next value in the list into the current value register (`%eax`). What addressing mode 
might we use here? Why?

<details>
<summary>Solution</summary>

We could use the **indexed** addressing mode because we have a starting location and a register 
to offset the address with.
</details>

5.	Compare the current value (`%eax`) with the current highest value (`%ebx`).
6.	If the current value is greater than the current highest value, replace the current highest 
value with the current value.
7.	Repeat.

The *if* instructino are called *flow control* instructions because they tell the computers which 
steps to follow and which paths to take.

Non-exhaustive list of flow control instructions :
-	Conditional jump
-	Unconditional jump
-	Loops

### Analysing the program

You can view the code for maximum.s [here](/src/maximum.s). Let's take a closer look at the program.

In the data section we can find the label `data_items` which refers to the location that follows it.

After this label we can find the `.long` directive which tells the assembly to reserve memory for the 
list of numbers that follows it.

Here are some of the directives we can use :
-	`.byte` : One storage location for each number. Numbers between 0 and 255
-	`.int` : Up to two storage locations for each number. Numbers between 0 and 65535
-	`.long` : Up to four storage locations. Numbers between 0 and 4294967295
-	`.ascii` : Up to one sstorage location. Ex : `.ascii "Hello there\0"`. Each ascii character 
has to be in quotes.

> We don't have a `.globl` declaration for `data_items` because it is refered only within this file.

Let's see how to use the indexed addressing to load one data item into `%eax`. Here is the 
instruction we use to do so :
```assembly
movl data_items(,%edi,4), %eax
```

We need to keep several thins in mind to understand this line :
-	`data_items` is the locatino number of the start of our number list
-	Each number is stores accross 4 storage locations (due to the `.long` declaration)
-	`%edi` is holding the index of our `data_item`

This line says "Start at the beginning of `data_items`, take the item number `%edi` and remember 
that each number takes up four storagef locations.

The general form of indexed addressing mode instructions in ASM is :
```assembly
movl BEGINNINGADDRESS(,%INDEXREGISTER,WORDSIZE)
```

> Remember that the `l` in `movl` stands for *move long* since we are moving a *long* value.

> Actually, the WORDSIZE is our **multiplier** for our indexed addressing. This means we take 
> the beginning of `data_items` and add `%edi * 4` to retrieve our needed number.

At the beginning of our `start_loop`, we have these instructions :
```assembly
cmpl $0, %eax
je end_loop
```

`cmpl` compare two long values. We compare 0 and the value stored in `%eax`. This comparison also 
affects the `%eflags` (or status) register. If the values are equal (*jump equal*) we jump to the 
`end_loop` location.

> The comparison is to see if the *second* value is greater than the *first* one.

There are many jump statements we can use :
-	`je` : Jump if the values are equal
-	`jg` : Jump if the second value is greater than the first
-	`jge` : `jg` or `je`
-	`jl` : Jump if the second value is less than the first one
-	`jle` : `jl` or `je`
-	`jmp` : Jump no matter what.

If the last loaded element was not zero, we go to :
```assembly
incl %edi
```
which increments the value in %edi by one.

## Addressing Modes

The general form of memory address references is :
```assembly
ADDRESS_OR_OFFSET(%BASE_OR_OFFSET, %INDEX, MULTIPLIER)
```

All of the fields are optional. To compute the address we do the following computation :
```assembly
FINAL ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPLIER * %INDEX
```
`ADDRESS_OR_OFFSET` and `MULTIPLIER` must both be constants while the other two must be registers. 
If any of the pieces is left out, it is just substituted with zero in the equation.

Except **immediate** mode, all of the addressing modes can be represented this way.

-	direct addressing mode
	-	ex : `movl ADDRESS, %eax` loads `%eax` with the value at memory address `ADDRESS`
-	indexed addressing mode
	-	We can use any general-purpose register as the index register. We can also have a constant 
	multiplier of 1,2 or 4 for the index register. Let's say we have a string of bytes as 
	`string_start` and wanted to access the third one and `%ecx` holds the value 2. To load 
	it into `%eax` we can run : `movl string_start(, %ecx, 1), %eax`
-	indirect addressing mode
	-	it loads a value from the address indicated by a register. ex : move the value at the 
	address held by `%eax` to `%ebx` by doing : `movl (%eax), %ebx`
-	base pointer addressing mode
	-	Similar to indirect addressing, except it adds a constant value to the address in the 
	register. ex : a record where the age value is 4 bytes into the record, with the address 
	of the record in `%eax` we can retrieve the age into `%ebx` with `movl 4(%eax), %ebx`

Here are the addressing modes that can't be represented using the general form :

-	immediate mode
	-	Used to load direct values into register or memory locations. ex : to load the number 
	12 into `%eax` we can run : `movl $12, %eax`
-	register addressing mode
	-	Register mode simply moves data in or out of a register. Register addressing mode was 
	used for the other operand in the examples.

Except immediate mode (which can only be a source operand), all modes can be source and destination 
operands.

The `movb` instruction allows to move one byte of data at a time (`movl` moves one word at a time).

Since the registers are word-sized and not byte-sized, we will only use a portion of the register.

For instance with `%eax`, if we wanted to work two bytes at a time we could just use `%ax`. `%ax` is 
the least-significant half (the last part of the number) of the `%eax` register. `%ax` is divided 
up into `%al` and `%ah`. `%al` is the least-significant byte of `%ax` and `%ah` is the most 
significant.

## Review

### Know the Concepts

1.	What does it mean if a line in the program starts with the '#' character?

<details>
<summary>Solution</summary>

It is a comment
</details>

2.	What is the different between an assembly language file and an object code file?

<details>
<summary>Solution</summary>

An assembly language file is human readable while an object code file is machine readable.
</details>

3.	What does the linker do?

<details>
<summary>Solution</summary>

The linker takes one or more object files and combines them into a single executable file. See 
the [linker wikipedia page](https://en.wikipedia.org/wiki/Linker_\(computing\))
</details>

4.	How do you check the result status code of the last program you ran?

<details>
<summary>Solution</summary>

By running the command `echo $?`
</details>

5.	What is the difference between `movl $1, %eax` and `movl 1, %eax`?

<details>
<summary>Solution</summary>

The first one is immediate mode. The value 1 goes into `%eax`. The second one is direct addressing 
mode. Whatever value that is at the address 1 goes into `%eax`
</details>

6.	Which register holds the system call number ?

<details>
<summary>Solution</summary>

In x86 assembly, the register `%eax` holds the system call number.
</details>

7.	What are indexes used for ?

<details>
<summary>Solution</summary>

Indexes are used to iterate over ranges of addresses, we use them to retrieve the next element in 
a sequence for example.
</details>

8.	Why do indexes usually start at 0?

<details>
<summary>Solution</summary>

Indexes usually start at 0 because doing so allow the index to be an offset in memory. To see 
more discussions about indexes starting at 0, see this [StackOverflow discussion](https://stackoverflow.com/questions/7320686/why-do-array-indices-start-at-zero-in-c)
</details>

9.	If I issued the command `movl data_items(, %edi, 4), %eax` and data\_items was address 3634 and 
`%edi` held the value 13, what address would you be using to move into `%eax`.

<details>
<summary>Solution</summary>

We would be using the address `3634 + 13 * 4 = 3686`
</details>

10.	List the general-purpose registers

<details>
<summary>Solution</summary>

There are 6 general-purpose registers :
-	`%eax`
-	`%ebx`
-	`%ecx`
-	`%edx`
-	`%edi`
-	`esi`
</details>

11.	What is the difference between `movl` and `movb`?

<details>
<summary>Solution</summary>

`movl` moves one word of data (4 bytes) while `movb` moves one byte of data.
</details>

12.	What is flow control ?

<details>
<summary>Solution</summary>

It is telling the computer which path to take to execute the program. See the [Control flow](https://en.wikipedia.org/wiki/Control_flow) 
wikipedia page.
</details>

13.	What does a conditional jump do?

<details>
<summary>Solution</summary>

It jumps (or not) to another location based on the value of a condition
</details>

14.	What things do you have to plan for when writing a program?

<details>
<summary>Solution</summary>

-	Where will our original data be stored?
-	What procedure will we need to follow to reach our goal?
-	How much storage do we need to carry out that procedure?
-	Will all the storage fit into registers or do we need to use some memory as well?

</details>

15.	Go through every instruction and list what addressing mode is being used for each operand

<details>
<summary>Solution</summary>

We need to go through every instruction in the `.text` section

I won't list all the instructions here but there are basically 3 access mode used :
-	Immediate access mode (ex : `$0`)
-	Register access mode (ex : `%eax`)
-	Indexed access mode (ex : `data_items(,%edi,4)`)
</details>

### Use the Concepts

1.	Modify the [first program](/src/exit.s) to return the value 3

<details>
<summary>Solution</summary>

Replace the `$0` on line 31 with `$3`
</details>

2.	Modify the [maximum](/src/maximum.s) program to find the minimum instead

<details>
<summary>Solution</summary>

We had to move the check for 0 (as 0 is less than the minimum if the list only consist of 
positive integers). We also had to either switch the positions of the registers in the comparison 
or replace the jle with a jge on line 35. See the [minimum](/src/minimum.s) source code.
</details>

3.	Modify the [maximum](/src/maximum.s) program to use the number 255 to end the list rather 
than the number 0

<details>
<summary>Solution</summary>

We can replace 0 with 255 in all the comparisons.
</details>

4.	Modify the [maximum](/src/maximum.s) program to use an ending address rather than the number 
0 to know when to stop

<details>
<summary>Solution</summary>

Here is the version using leal to compute the addresses and implementing a base check to ensure
that the number of items provided is the right one. See the [maximum\_addr program](/src/maximum_addr.s)
</details>

5.	Modify the [maximum](/src/maximum.s) program to use a length count rather than the number 0 
to know when to stop.

<details>
<summary>Solution</summary>

See the new [maximum\_length program](/src/maximum_length.s) to see the implementation using a 
counter and the maximum length.
</details>
