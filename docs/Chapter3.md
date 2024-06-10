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
