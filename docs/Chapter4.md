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
	-	Data storage that a function uses while processing that is not thrown away afterwars, but 
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
