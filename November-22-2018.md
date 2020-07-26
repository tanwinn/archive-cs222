Friday 	November 9 2018

# Reasoning about programs

Definition:
A precondition is an assertion that holds before an expression executes

A postcondition is an assertion // after //
 
Example:
; Proecondition:
assert 3+3==6
x=3
; Postcondition
assert x+3==6
(pre/post can have multiple cases)

This pairs of assertions is related:
Here, postconditions is just the precond with the code we executed changing it slightly

#Reasoning about simpe imperative programs:

Hoare triple is a triple (precond, expression, postcond). 
Notation: {P} expr {Q}
e.g: {3+3==6} x=3 {x+3==6}

Def: Hoare triple is true if, whenever P is true before expr runs, then Q is true after it runs

def HoareTree(n tuple):
	if P:
		run expr
		return Q
	return Q
	
### Correctness of a program definition
#### Partial correctness:
Using logic of Hoare triples, can prove your code does whtat you purpose it to do

#### Total correctness:
Partial correctness plyus code terminates

Hoare Triple examples:
1) {true} x=x\*2 {x==x\*2}
--> False (e.g. 1)
2) {true} x=x\*2 {x is even}
--> False, x can be not integer
3) {x is an integer} x=x+2 {x is even}
--> True
4) {true} x=x\*2 {x>0}
--> False, x can be negative
5) {false} x=x\*2 {x is odd}
--> True
6) {false} while True pass {x is even} 
--> Technically true

### Logical Rules:
- Assignment
- Sequencing
- Replacement
- While


#### Assignment rule:
Any triple of the form {Q [E/x]} x=E {Q} is true
Q[E/x] means: takes Q, and replace all the x's with E's

#### Sequencing rule:
P --> expr 1 --> R --> expr 2 ---> Q
If 
{P} expr 1 {R} 
and {R} expr 2 {Q}
are both true
Then the thingy is true

#### Replacement Rule:
Given {P} expr {Q} is true,
{P'} expr {Q} provided:
P' is equivalent to P, or P' implies P
P' is equivalent to Q, or Q implies to P'

#### While Rule:
Reasoning about loops While B: expr
Flowchart: (In cs222 folder)
In while rule, P is called a loop invariant
Def: A loop invariant is an assertion that is true. Before and after every iteration
Good coding: write loop with invariant in mind
