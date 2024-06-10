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
