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
	accessed. ex : if register contains value 4, we use whatever value is at memory location 4.
-	Base pointer addressing mode
	-	Same as indirect addressing but with a number called *offset* to add to the register's 
	value before using it for lookup.

## Review

### Know the Concepts

1.	Describe the fetch-execute cycle

<details>
<summary>Solution</summary>

The fetch-execute cycle is the sequential execution of instructions by the CPU. It 
uses the Program Counter to the fetch the next instruction from the memory and then 
executes it.
</details>

2.	What is a register? How would computation be more difficult without registers?

<details>
<summary>Solution</summary>

There are high-speed memory locations in the computer. Without registers, there couldn't 
be any computation as they are the place the CPU uses to do the computations.
</details>

3.	How do you represent numbers larger than 255?

<details>
<summary>Solution</summary>

We can use combinations of bytes to represent them. The classical is 4-bytes combinations.
</details>

4.	How big are the registers on the machines we will be using?

<details>
<summary>Solution</summary>

We are going to use 4 bytes registers	
</details>

5.	How does a computer know how to interpret a given byte or set of bytes of memory?

<details>
<summary>Solution</summary>

The computer doesn't. It is the programer that tells the computer how to interpret 
the memory.
</details>

6.	What are the addressing modes and what are they used for?

<details>
<summary>Solution</summary>

Addressing modes are the different ways we have to access data from memory.
</details>

7.	What does the instruction pointer do?

<details>
<summary>Solution</summary>

The instruction pointer holds the address of the next instruction to be executed.
</details>

###	Use the Concepts

1.	What data would you use in an employee record? How would you lay it out in memory?


<details>
<summary>Solution</summary>

For an employee record, I'd use the following fields :

-	Name
-	Age
-	Address
-	Id

To lay it out in memory I'd use the following structure :
```txt
Start of record :
	Employee's name pointer (1 word) - start of record
	Employee's age (1 word) - start of record + 0x4
	Employee's address pointer (1 word) - start of record + 0x8
	Employee's id (1 word) - start of record + 0xc
```
</details>

2.	If I had the pointer the the beginning of the employee record above

<details>
<summary>Solution</summary>

Depending on the piece of data I have to access, there would be two modes I could use :

1.	To acces the name or the address, I would use the **base pointer** adressing mode, as we 
only store a pointer to the employee's name and address.
2.	To access the age or the id of an employee, I would use the **indexed** addressing mode, as 
we store within the record the age and the employee's id.

</details>

3.	In base pointer addressing mode, if you have a register holding the value 3122, and an 
offset of 20, what address would you be trying to access?

<details>
<summary>Solution</summary>

The address `3122 + 20 = 3142`
</details>

4.	In indexed addressing mode, if the base address is 6512, the index register has a 5 and the 
multiplier is 4, what address would you be trying to access?

<details>
<summary>Solution</summary>

The address is `6512 + 5 * 4 = 6432`
</details>

5.	In indexed addressing mode, if the base address is 123472, the index register has a 0, and the 
multiplier is 4, what address would you be trying to access?

<details>
<summary>Solution</summary>

The address is `123472 + 0 * 4 = 123472`
</details>

6.	In indexed addressing mode, if the base address is 9123478, the index register has a 20, and 
the multiplier is 1, what address would you be trying to access?

<details>
<summary>Solution</summary>

The address is `9123478 + 20 * 1 = 9123478`
</details>


### Going Further

1. What are the minimum number of addressing modes needed for computation?

<details>
<summary>Solution</summary>

Only [one mode](https://stackoverflow.com/questions/35221379/what-is-the-minimum-number-of-addressing-modes-necessary-for-computation), 
the **indirect addressing mode** is needed to do all the computations.

</details>

2.	Why include addressing modes that aren't strictly needed?

<details>
<summary>Solution</summary>

We can include them for [conveniance](https://stackoverflow.com/questions/35221379/what-is-the-minimum-number-of-addressing-modes-necessary-for-computation).

</details>

3.	Research and then describe how pipelining (or one of the other complicating factors) affects 
the fetch-execute cycle.

<details>
<summary>Solution</summary>

See : 
-	[What are the common Pipeline hazards of pipelines?](https://stackoverflow.com/questions/8700440/what-are-the-common-pipeline-hazards-of-pipelines) *Stackoverflow Discussion*
-	[What is Pipelining?](https://www.techtarget.com/whatis/definition/pipelining) *An article about pipelining*

Pipelining allows the processor to process more instructions simultaneously, while reducing the 
delay between completed instructions. However, it can introduce new problems such as **Data dependencies** 
or **Branching problems**
</details>

4.	Research and then describe the tradeoffs between fixed-length instructions and variable-length 
instructions.

<details>
<summary>Solution</summary>

See :
-	[Restricted instruction set computer](http://www.cs.emory.edu/~cheung/Courses/255/Syllabus/6-CPU/risc-cisc.html)
-	[Instruction decoding when instructions are length-variable](https://stackoverflow.com/questions/8204086/instruction-decoding-when-instructions-are-length-variable) *StackOverflow Discussion*
-	[RISC vs CISC](https://cs.stanford.edu/people/eroberts/courses/soco/projects/risc/risccisc/) 
*Comparison in Stanford Lecture*

To summarize briefly these 3 sources, we could say that while variable-length instructions allow 
us to lower the number of instructions needed for a program, the use of fixed-length instructions 
reduces the time taken by an instruction, thus improving the speed.
</details>
