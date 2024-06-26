# Chapter 4 | All About Functions

## How Functions Work

Functions are composed of several different pieces :

-	function name
	-	symbol that represents the address where the function's code starts. In asm, the symbol 
	is defined by typing the function's name as a label before the code
-	function parameters
	-	data items explicitly given to the function for processing.
-	local variables
	-	Data storage that a function uses while processing that is thrown away when it returns
-	static variables
	-	Data storage that a function uses while processing that is not thrown away afterwards, but 
	is reused for every time the function's code is activated. They're generally not used unless 
	**absolutely** necessary, as they can cause problems later on see 
	[this StackOverflow discussion](https://stackoverflow.com/questions/7026507/why-are-static-variables-considered-evil) 
	for more insight about how and why static variables may be bad.
-	global variables
	-	They're data storage that a function uses for processing which are managed outside 
	the function. Configuration values are often stored in global variables. See 
	[this discussion](https://wiki.c2.com/?GlobalVariablesAreBad) 
	on why the global variables should be avoided whenever possible.
-	return address
	-	The return address is an "invisible" parameter in that it isn't directly used during the 
	function. It's a parameter which tells the function where to resume executing after the function 
	is completed. It is needed to get back to wherefer the function was called from. In assembly 
	language, the `call` instruction handles passing the return address for us and the `ret` 
	instruction handles using that address to return back to where the function was called from.
-	return value	
	-	The return value is the main method of transferring data back to the main program

The way the variables are stored and the parameters and return values are transferred by the 
computer varies from language to language. This variance is known as a language's *calling 
convention* because it describes how functions expect to get and receive data when they're called.

Assembly language can use any calling convention. In the rest of the book we'll use the calling 
convention of the C programming language.

## Assembly-Language Functions using the C Calling Convention

### The Stack

Each computer program that runs uses a region of memory called the **stack** to enable functions 
to run properly. We can think of it as a pile of papers on our desk.

The computer's stack lives at the very top addresses of memory (it grows downwards).

The `pushl` instruction is used to push either a register or memory value onto the top of the stack (
which is actually the bottom of the stack memory) while `popl` is used to pop values off the top (which 
actually is the bottom of the memory) of the stack and place it into a register or memory location of 
choice.

The stack register, `%esp`, always contains a pointer to the current top of the stack.

Everytime `pushl` is called, `%esp` gets subtracted by 4 so it points to the new top of the stack. 
Similarly, when `popl` is called, 4 gets added to `%esp` and the previous top value is put into the 
register/memory location specified.

If we want to access the value on the top of the stack without removing it, we can simply use `%esp` 
in indirect addressing mode. For example, the following code moves the top of the stack into `%eax` :
```assembly
movl (%esp), %eax
```

If we'd like to retrieve the value right below the top of the stack, we can issue the instruction : 
```assembly
movl 4(%esp), %eax
```

### Function execution

Before executing a function, a program pushes all of the parameters for the function onto the stack 
in the **reverse order** that they are documented. Then it issues a `call` instruction to indicate 
whcih function it whishes to start.

The call instruction does two things :

1.	It pushes the address of the next instruction, which is the return address, onto the stack
2.	It modifies the instruction pointer `%eip`, to point to the start of the function.

At the time the function starts, the stack looks like this :
```text
Parameter #N
...
Parameter #2
Parameter #1
Return Address <--- (%esp)    #This is the top of the stack
```

The function can now start working.

The first thing it does is save the current base pointer register, `%ebp` by doing `pushl %ebp`. 
The base pointer is a special register used to access function parameters and local variables. 
Next, it copies the stack pointer to `%ebp` by doing `movl %esp, %ebp` (we don't directly use `%esp` 
because we could need to push other values onto the stack).

`%ebp` will always be where the stack pointer was at the beginning of the function, it is thus a more 
or less constant reference to the *stack frame* (which are all the stack variables used within a function 
including parameters, local variables and the return address).

At this point, the stack looks like this:
```text
Parameter #N    <--- N*4 + 4(%ebp)
...
Parameter #2    <--- 12(%ebp)
Parameter #1    <--- 8(%ebp)
Return Address  <--- 4(%ebp)
Old %ebp        <--- (%esp) and (%ebp)
```

Next, the function reserves space on the stack for any local variables it needs. Let's say we're going to 
need two words of memory to run a function. We run :
```assembly
subl $8, %esp
```
to reserve the space for our two words of memory. We can use the stack for local storage and when we return, the stack frame 
alongside our variables will go a way. This is why they are called local to the function.

Our stack now looks like this:
```text
Parameter #N     <--- N*4 + 4(%ebp)
...
Parameter #2     <--- 12(%ebp)
Parameter #1     <--- 8(%ebp)
Return Address   <--- 4(%ebp)
Old %ebp         <--- (%esp) and (%ebp)
Local Variable 1 <--- -4(%ebp)
Local Variable 2 <--- -8(%ebp) and (%esp)
```
We can access all the data we need by using base pointer addressing using different offsets from `%ebp`

> We could use any register for base pointer addressing but the x86 architecture makes using `%ebp` a lot faster.

Global and static variables are treated exactly the same by Assembly language and are accessed like any other memory. 
The only difference between them are that global variables are used by many functions while sttic variables are used 
by only one.

When the function is done executing, it does 3 things:

1.	It stores it's return value in `%eax`
2.	It resets the stack to what is was when it was called (gets rid of the current stack frame and puts the stack frame 
of the calling code back into effect).
3.	It returns the control back to wherever it was called from. This is done using the `ret` instruction, which pops 
whatever value is at the top of the stack and sets `%eip` to that value.

> To return, we have to reset `%esp` and `%ebp` to what they were before the function began.

To return from the function, we have to do the following:
```assembly
movl %ebp, %esp
popl %ebp
ret
```
The calling code has gained the control back and can now examine `%eax` for the return value. It also needs to pop off all 
the function parameters pushed onto the stack in order to get the stack pointer back to where it was (one can also add 
4 * number of params to `%esp` using the `addl` instruction if the parameters value are not needed anymore).

> :warning: Destuction of Registers
> When a function is called, we must assume that everything written in our registers will be wiped out. The only register that 
> will be restored is `%ebp`. `%eax` is guaranteed to be overwritten and the others will likely be. If there are values to be saved 
> before calling a function, the registers should be pushed onto the stack before pushing the paarameters. We will retrieve them 
> by popping them off in reverser order after popping off the parameters.
