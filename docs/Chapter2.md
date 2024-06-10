# Chapter 2 | Computer Architecture

## Chapter Summary

CPU(Central Processing Unit) elements :
-	Program Counter
	-	Holds the memory address of the next instruction to be executed
-	Instruction Decoder
	-	What the Instructionn means
-	Data Bus
	-	Connection between the CPU and memory (actual wire that connects them)
-	General-purpose registers
	-	Registers are what the computer uses for computations. It is the place on our 
	desk. While informations can be tucked away into the folders and drawers (the memory), 
	registers keep track of the numbers we're currently manipulating. There are the place 
	where the main action happens.
-	Arithmetic and logic unit
	-	Where the instruction is actually executed

*See also* : Cache hierarchies, superscalar processors, pipelining, branch prediction, 
out-of-order execution, microcode translation, coprocessors.

**Address** : Number attached to each storage location.

**Byte** : Size of each storage location (number between 0 and 255 on an x86 processor).

**Word size** : size of a typical register. *x86 processors have four-byte words*. 
Addresses are also 1 word long.

Data Accessing Methods :
-	immediate mode
	-	The data to access is embedded in the instruction itself (ex : init something to 0)
-	register addressing mode
	-	The instruction contains a register to access
All the following modes will deal with memory addresses
-	Direct addressing mode
	-	Instruction contains the memory address to access (ex : load register x with data at 
	address y)
-	Indexed addressing mode 
	- Instruction contains memory address to access and also specifies and *index register* 
	to offset that address. ex : address 2002 and a register that contains value 4, the data 
	loaded will be from the address 2006. *On x86 processors we can specify a multiplier for 
	the index*
-	Indirect addressing mode
	-	Instruction contains a register that contains a pointer to where the data should be 
	accessed. ex : if register contains value 4, we use whaterver value is at memory location 
	4.
-	Base pointer addressing mode
	-	Same as indirect addressing but with a number called *offset* to add to the register's 
	value before using it for lookup.

## Review

### Know the Concepts

-	Describe the fetch-execute cycle
	-	The fetch-execute cycle is the sequential execution of instructions by the CPU. It 
	uses the Program Counter to the fetch the next instruction from the memory and then 
	executes it.
-	What is a register? How would computation be more difficult without registers?
	-	There are high-speed memory locations in the computer. Without registers, there couldn't 
	be any computation as they are the place the CPU uses to do the computations.
-	How do you represent numbers larger than 255?
	-	We can use combinations of bytes to represent them. The classical is 4-bytes combinations.
-	How big are the registers on the machines we will be using?
	-	We are going to use 4 bytes registers	
-	How does a computer know how to interpret a given byte or set of bytes of memory?
	-	The computer doesn't. It is the programer that tells the computer how to interpret 
	the memory.
-	What are the addressing modes and what are they used for?
	-	Addressing modes are the different ways we have to access data from memory.
-	What does the instruction pointer do?
	-	The instruction pointer holds the address of the next instruction to be executed.

###	Use the Concepts


