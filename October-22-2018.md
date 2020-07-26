October 22, 2018
#Types

When interpreter returns a pair (value.store)
How know made a mistake? >> Some weird errors or wrong putput later on
Also, our interpreter is full of calls like integer? ptr? func? etc --> Make code longer and harder to read
In our interpreter, 'fun and d
ptr are effectuvely "reserve ketwords', which is unexpected.
Interpreters in textbooks are shorter and lack these problems. How?

##Definition: 
A type is an identifierto every piec of data in a program
-> Wnat a type t be descriptive
-> A single piece of data can have more than one type
e.g: 3 can be an integer, number, "3" can be a string.
(Language specific)

##Types of typing: 
static vs. dynamic, and strong vs. weak

1. Static typing:
Types are part of the syntax of the language 
E.g: C, Typed Racket

2. Dynamic typing:
Types only are checked at runtime, not part of the syntax
E.g: Python, Racket

3. Strong typing:
Types are fixed by assignment, can's assign later a different type 
E.g: C, Typed Racket

4. Weak typing:
Types of variables can change 
E.g: Python, Racket (let ([x 5]) (set! x "5"))

####Typical:
Stratic <> Strong
Dynamic <> Weak

####Less common:
Dynamic <> Strong

####Rare:
Static <> Weak

##Advantages
###Static types:
1. Readable codes
2. Type error happens at parse time, are helpful/descriptive --> improve correctness

###Dynamic types:
1. Easier to write codef
2. Faster parse-time

##Static Type checks:
####How does it work?
Example:
int x = 3;
x = 7;
x = "six";
Lexical operations: x is declared as an int type --> 3 is an int, so x=3 is typechecks, 7 is //, "six" is a string, which is a string, fails to typechecks.

###Neccessity of type declaration:
Example:
x = 3; x = 7; x = "six"; --> static, strong
Can this be statically typed? Yes, type inference
