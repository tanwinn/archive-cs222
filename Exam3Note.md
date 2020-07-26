We changed the associative list data structure. Why?
\<
- Our new structure (a bunch of pairs) allows us to typecheck since the old struct (two lists) relied on equal lengths, which cannot be checked at compile time.

# Assertions

- Dynamic check of some property that is declared to hold (you still don't get your errors until run time though)

### Classical Assertion

```Python
def isPrime(n):
	assert isinstance(n, int) and n > 1
	for d in range(2,n):
		if n%d == 0
			return False
	return True
```

Here, you get an error if the assertion fails, otherwise proceeds as if nothing happened.

What about assertions in functional programming?

- Classical assertions inherently depend on sequencing, which functional programming doesn't like

Assertion is now a function applied to some piece of data, `x`. If the assertion fails, you get an error. If the assertion fails you get an error, if it succeeds it evaluates to `x`.

**This is called a contract**. You get a contract violation when an assertion fails. Racket has built in contracts, but they're weird. Book is good here.

### Contract Constructor

```Lisp
(define (make-contract pred)
	(lambda (x)
		(if (pred x)
			x
			(error "Contract Violation"))))
```

(All (A) (-> (-> A Boolean) (-> A A)))

An example of using an assertion
```Lisp
(: n-ones (-> Integer (Listof Integer)))
(define (n-ones n)
	(let ([n ((make-contract 
				(lambda (n) (and (integer? n) (\<= 0 n))))
				 n)]) 
	((if (= n 0)
		 null
		 (cons 1
			   (ones (- n 1)))))))
```
But we could have done this statically too...

Example (Impossible to be static)

```Lisp
(define (equal-length-pred-maker list-to-compare-to)
	(lambda (list-to-check) (= (length list-to-check)
							   (length list-to-compare-to)))

(define (make-assoc-list syms vals)
	(cons syms ((make-contract (equal-length-pred-maker syms)) vals)))
```

# Pros and Cons of Assertions / Contracts

### Pros
* Useful error messages
* Readability of checks
* Use cases similar to static type checking
* assertions are kind of like documentation
* Shorter error checks that using `if` statements
* Assertions let you reason about your code


### Cons
* Crashes your program when it fails
* Overly complicated (especially in functional programming)
* Assertions can be inefficient
* Dangerous if not restrained (e.g. mutations)

# Logical Reasoning About Code

Sometimes it's not enough to write code that seems to work. Sometimes you need to write a program and prove rigorously that it works. 

- Example: Safety Critical Software
- Stuff where you can't edit the code once it's deployed
- Hardware applications
- Mars Rovers

# Reasoning and Programs

- A **precondition** is an assertion that holds before an expression executes

- A **postcondition** is an assertion that holds after an expression executes

```Python
# Precondition
assert 3+3 = 6
x = 3
# Postcondition
assert x + 3 = 6
```

This pair of assertions is related. Here the postcondition is just the precondition with the code we executed changing slightly

- A **Hoare Triple** is a triple (precondition, expression, postcondition)

Notation **{P} expr {Q}**

{3+3==6} x=3 {x+3==6}

- A Hoare triple is **true** if, whenever P is true before expr runs, then Q is true afterwards

- Correctness of a program

Partial Correctness &rarr; using logic of Hoare triples, can prove your code does what you purport it to do

Total Correctness &rarr; partial correctness plus code terminates

# Hoare Tripe Examples

1. {true} x=x\*2 {x==x\*2}} False
2. {true} x=x\*2 {x is even} False
3. {x is an int} x=\*2 {x is even} True
4. {true} x=\*2 {x>0} False
5. {true} x=\*2 {x is odd} True
6. {tru} while True: pass {x is even} Technically True since we never get to the post condition

# Logical Rules for Hoare Triples

- Assignment
	- any type of the form:
	- {Q [E/x]} x = E {Q} is true
	- Q [E/x] means "Take Q, and replcae all the x's wwith E's"
- Sequencing
	- If {P} expr1 {R} and {R} expr2 {Q} are both true then {P} expr1 expr2 (in sequence) {Q}
- Replacement
	- Given {P} expr {Q} is true, {P^1} expr {Q^1} provided
- While
	- Reasoning about loops 
	- general case can't say anything
	- Special Case: P, P^1, P^2 are all P
	- If {P and B} expr {P} is true then {P} while B: expr {P and NOT BB} is true
	- In the while rule, P is  called a **loop invariant** &rarr; is an assertion that is true before a loop begins and after every iteration

Example
```Python
val = 1 
i = 0
while i != n:
	i = i + 1
	val = val * i
return val
```

val is i factorial is a useful loop invariant

```Python
def fib(n):
	last = 1
	two_ago = 0
	i = 1
	while i\<n:
		cur = two_ago + last
		two_ago = lst
		bst = cur
		i = i + 1
	return last
```

To prove a loop invariant:
1. Prove that it holds at the start
2. Prove that it holds after every variation

If code is well written, the loop should be some partial solution to the problem.

Loop Invariants for fibonnaci:

1. last is the ith fib number
2. last + two_ago the i+1 th fib number
3. two_ago is the i -1 fib number
4. (1) and i \<= n

**REMEMBER** the while rule &rarr; If {P and B} expr {P} then {P} while B: expr {P and not(B)}

What we want to include is {last is the nth fib number and i>=n} which should be equivalent to {P and not(B)}

* not(B) is i >= n

# Proving Partial Correctness of factorial

* Function fac has a precondition {n is a nonnegative integer}
* Postcondition {val is n factorial}

* Loop invariant {val is i!}

{,val is i! and i=n}


# Parsing (for real this time)

- Given the text of  a program, convert it to a useful internal representation

# 3 Parts to Parsing

1. Tokenizing
2. Concrete Syntax &rarr; start with your tokens and make a tree
3. Abstract Syntax &rarr; take the tree of tokens and turn it into a useful internal representation

Abstract Syntax Tree &rarr; structural representation of a program that's independent of the language it is written in

```Python
def dbl(x):
	return 2*x
```
```C
int dbl(int x)
{
return 2*x;
}
```
```Lisp
(define (dbl x)
	(* 2 x))
```

Assuming we live in a universe of integers, these could all have the same Abstract Syntax Tree (AST). They do the same thing in the same way.

# Tokenizing

- Done by a tokenizer (scanner, lexer)
- Takes the text of the program and breaks it up into tokens. Tokens are:
	- Lexeme: A word
	- Token Type: A tag that is associated to a lexeme
	- Examples Lexemes: 10, (, +,  3.79
	- Example tokens:
		- 10 &rarr; intT
		- + &rarr; addT
		- ( &rarr; lparenT
		- 3.79 &rarr; floatT
		- the T at the end signifies that they are token types, not data types

```Python
def dbl(x)
	return 2*x
```

def : defT

dbl : idT

(   : lparenT

x   : idT

)   : rparenT

:   : colonT

[Usually ignore whitespace, but python whitespace matter. \n and \t matters]

\n  : newLineT

\t  : tabT

return : returnT

2   : intT

\*   : mulT

x   : idT

---
**Replacing a token with another token of the same type should not change the phrase structure of the program (doesn't chnage AST)**

---
```C
int dbl(int x)
{
return 2*x;
}
```
- int &rarr; typeT
- dbl &rarr; idT
- ( &rarr; lparenT
- int &rarr; typeT
- x &rarr; idT
- ) &rarr; rparentT
- { &rarr; lcurlyT
- return &rarr; rreturnT
- 2 &rarr; idT
- \* &rarr; mulT
- x &rarr; idT
- } &rarr; rcurlyT

---
 
Scanner

- Figures out where to break lexemes
- tags them
- skips comments/whitespace

Parser

- steps 2 and 3 (Makes the trees)
- uses a sequence of token types to construct the phrase structure (concrete syntax tree) and then the abstract syntax tree after
- Lastly, it puts the lexemes back in for token types

# Grammar / Formal Language

Formal language &rarr; a set of strings; valid string: a string in the language; invalid string: string not in the language

**Alphabet** : set of allowable characters that can appear in strings

All strings over the alphabet {3}
	- "" , 3, 33, 33333, ...

Over {a,b,c,...,z} 
	- the set of all english words

Alphabet {0,1}	all strings with an even number of 0s

# There are Various Classes of Formal Languages

- Trade off between poewr and efficiency
- *Formalization* Chomsky hierarchy
	- In this class we care about:
		- Regular Languages (Type 3 in the hierarchy)
		- Context Free Languages (Type 2 in the hierarchy
		- *Lower type numbers are more power, less efficient*

- Tokenizing Uses Regular languages

**Regular Languages**

Three definitions
- Regular Expressions &rarr; pattern for string generation or matching
	- Formal Definition: (Recursive) 
		- Base cases
			1. the empty set is a regex that matches nothing
			2. epsilon is a regex that matches the empty string
			3. for any alphabet symbol a, a is a regex. It matches "a" and nothing else
		- Recursive Cases
			1. Union &rarr; if A and B is a regex, then A Union B is a regex that matches any string A or B matches
			2. Concatenation &rarr; if A and B are regex, then AB is a regex. It matches any string that can be decomposed into a prefix that A matches and the rest that B matches
			3. Kleene Star &rarr A is a regex, A* is a regex. It matches any string that can be broken into pieces, each matching A

	- Example : ((0|1)2)\* matches strings of equal length, start with a 0 or 1, and alternate between non-2's and 2's
	- 2 other operations
		1. Kleene Plus &rarr; A+ = AA* (so it's like 1 or more instead of 0 or more)
		2. Optional &rarr; A? = (epsilon | A) (so A occurs once or never)
- Finite Automata &rarr;
	- A finite automaton is a type of machine (simple computer) with three properties
	1. no memory
	2. consist of a finite number of states
		- a special state called the start state and special states called accept states
	3. transition rules
		- given current state and next input symbol, tells you which state to go to next
	- Notation 
		- States get circles
			- starts are &rarr; O
			- accept states double circles
			- transition rules are arrows with alphabet symbols on them
	- Computation : start in the start state, read input left to right, follow transition rules, if you end in an accept state say yes, if not say no
- Regular Grammars &rarr;

- Programming Language Alphabets are really big so we have shorthands
	- [a-z] = a | b | c | ... | z
	- [A-Z]
	- [0-9]
	- [A-Za-z0-9] = [A-Z]  | [a-z] | [0-9]
	- [\^a] anything not matching a
		- eg [\^0-9]
	- The dot (bullet point) represents any single character

Examples Write Regexes for 

- L = strings of 0s and 1s with an even numer of 0s

(01\*0 | 1)\*

- intT

[1-9][0-9]\* | 0

Give a Regex and a string of length n, the time to check is O(n)

# Monday back From Break

Combine all the FAs into one giant mahines **(conjoin at start state)**. You have one startstate that branches out to  other accept states or machines.

Read the input until you hit white space. Check which accept states you're in. If you are in no accept states, then you have an invalid token. If you're in exactly one accept state, that's your token type. If you're in more than one accept state. Token type is the highest precedence among all accept states

# Grammars

- Formal specification of a language

1. Variables (non-terminals)
2. Terminals (alphabet symbols)
3. Production Rules (rewrite rules)

- Special 'Start Variable' S
- Production Rules (alpha &rarr; beta)
	- "In one step, can rewrite alpha to beta"
- Language defined as: Start from S, apply rewrite rules until no more variables. What strings can you write?

Example

- S &rarr; 0A
- S &rarr; 1S
- S &rarr; epsilon
- A &rarr; 0S
- A &rarr; 1A

Shorthand 

- S &rarr; 0A | 1S | epsilon
- A &rarr; 0S | 1A

Variables = S and A
Terminals = 0, 1 , epsilon
5 production rules

- 001 is in the language of this grammar
- S &rarr; 0A &rarr; 00S &rarr; 001S &rarr; 001
- 101 is not in the language

This grammar is an even number of zeroes. S is the even state and A is the odd state.

# Conventions

- Capital letters for variables
- S for start variables
- non capitals for terminals

- **Different Conventions for Programming Languages** variables enclosed by angled brackets \<>; terminals are anything NOT enclosed by \<>; start variables is leftside of the first production rule

# Grammar Strength
- The strength of a grammar is determined by what kind of production rules are permitted.

Regular Grammar 

- Rules can be of form
	- A &rarr; aB
	- A &rarr; a
	- A &rarr; epsilon
- At most one variable in a derivation
- Variables correspond to states in finite automata


# Limitations of Regularity

- RE for math expressions?
	- integers
	- floats
	- operations
	- parentheses &rarr; regular expressions can find these, but cannot balance them

# Context-Free Grammar

- Production rules of A &rarr; alpha
	- A is any variable
	- alpha : sequence of vars and or (terminal) ; sentential form
# CFG for Nested, balanced parentheses

S &rarr; (S)
S &rarr; SS
S &rarr; epsilon

Grammar for Math
-

\<Expr> &rarr; \<Expr>\<Op>\<Expr> | lparenT \<expr> rparenT | intT | floatT | idT
\<Op> &rarr; addT | mulT

Derivation

- Description of how to start from S and reach a given string

- **Leftmost Derivation** always expand the leftmost variable first
- **Rightmost Derivation** always expand the right most variable first

Example (Leftmost Derivation)

- (5 + 2) * 6
	- start with \<expr>
	- \<expr>\<op>\<expr>
	- \<lparenT>\<expr>\<rparenT>\<op>\<expr>
	- \<lparenT>\<expr>\<op>\<expr>\<rparenT>\<op>\<expr>
	- ... ...


# Context Free Grammar for Math

\<Expr> &rarr; \<Expr>\<Op>\<Expr> | lparenT \<expr> rparenT | intT|floatT | idT

\<Op> &rarr; addT | subT  | mulT | divT


**Derivations lead to parse trees**

- Known as context syntax trees in CS

Consider \<Expr> (5+2)\*6

	- \<Expr>\<Op>\<Expr>
	- \<lparenT>\<Expr>\<rparenT>\<Op>\<Expr>
	- \<lparenT>\<Expr>\<Op>\<Expr>\<rparenT>\<Op>\<Expr>
	- \<lparenT>\<intT>\<Op>\<Expr>\<rparenT>\<Op>\<Expr>
	- \<lparenT>\<intT>\<addT>\<Expr>\<rparenT>\<Op>\<Expr>
	- \<lparenT>\<intT>\<addT>\<intT>\<rparenT>\<Op>\<Expr>
	- \<lparenT>\<intT>\<addT>\<intT>\<rparenT>\<mulT>\<Expr>
	- \<lparenT>\<intT>\<addT>\<intT>\<rparenT>\<mulT>\<intT>

*Leaves are terminals. Root is start variable*

Different derivations (left to right or right to left) can give same parse trees. Can number internal nodes to indicate order expanded in.

Parse Tree &larr;&rarr; phrase structure

If you replpace a token with another token of the same type it doesn't change the phrase structure.

--- 

Exercise 3 + 2 * 7

---

If you can generate multiple parse trees from the same expression, this is a property called **ambiguity**. A grammar is ambiguous if there is an expression with more than one parse tree.

The parse tree determines the structure of the code, which, in turn determines what it evaluates to.

# Ways to resolve ambiguity

1. Require Parentheses
2. Use Prefix Notation
3. Use Postfix notation

- These all change the structure of the language

4. Introduce order of operations to the grammar
	- Operator Precedence (do \* before -)
	- Operator Associativity (eg left to right)

---

# Non-Ambiguous Math Grammar

- \<Expr> &rarr; \<Expr>\<LowerPrecOp>\<Term> | \<Term>
- \<Term> &rarr; \<Term> \<HIgherOP>\<factor> | \<factor>
- \<factor> &rarr; \<lparenT> \< expr> \<rparenT> | intT|flaotT|idT
- \<lowerPrecOp> &rarr; addT | subT 
- \<higherPrecOp> &rarr; mulT |divT

---

3+2\*7

\<Expr>\<LowerPrecOP>\<Term>
\<Term>\<LowerPrecOP>\<Term>




# Parsing Process

- Top-Down; easier
- Bottom-Up; more powerful


Top Down Parsing
-

Start from S try to construct a parse tree via a leftmost derivation

At each step; from current sentenstial form (seq of var and terminals) decide a production rule to apply to leftmost variable


## Naive Approach

- Try a rule. Did it work? Great! If not, go back, and try another rule. If runout of rules adnd didn't derive string then fail. 

## Issues

- Inefficient
- Non Termination

Smart Idea
- Modify  parser so it can guess the rule it should.
- Pro: Way more efficient
- con: only works in certain restricted cases

# LL Parsing

- left to right: leftmost

Decide
- 

- peek at the next token
- figure out what rule allows that token to be next
- or if there's a rule that can make epsilon i can 't read the rest

- grammar that lets you do this in a unique way at each step call an LL(1) grammar

Example


\<expr> &rarr; lparenT \<op>\<int>\<ints> rparenT
\<op> &rarr; addT | mulT
\<ints> &rarr; \<int>\<ints> | epsilon
\<int> &rarr; \<expr> | intT

Expression

(+ (\* 2 3) 4)

Unreadable Tree Put on Board

# First and Follow Sets

alpha is a variable or terminal

First(alpha) = set of terminals that can be the first symbol of something derived from an alpha

A is a variable

Follow(A) is a set of terminals thatcan come after something from A

# Rules (recursive definitions)

- Base Cases

First(epsilon) = {epsilon}
First(a) = {a}
First(alphaBeta) = first(alpha) U first(beta) ~ if you can get epsilon from alpha otherwise it's just first(alpha)
First(alpha | beta) = first(alpha) U first(beta)

Example

first(epsilon) = {epsilon}
first(token types) = {itself}
first(expr)  = {lparenT}
first(op) = {addT, mulT}
first(int) = {lparenT, intT}
first(ints) = {lparenT, intT, epsilon}

## Rules for Follow

1. $ is in Follows(S) (base case)
2. production A &rarr; alphaBbeta
	- everything but epsilon in first(beta)
3. prodcution A &rarr; alphaB or alphaBbeta with epsilon in first of beta
	- everything in follow(A) goes in follow(B)

Follow(expr) = {$, rparenT}
Follow(op) = {lparenT, int}
Follow(int) = {lparenT, intT, epsilon, rparenT}
Follow(ints) = {rparenT}

### LL Parsing Using First and Follow

Given production rules A &rarr; alpha

Define: Select(A &rarr; alpha) = 
		- first(alpha) if alpha cannot turn into epsilon
		- first(alpha) if alpha can turn in epsilon

- Select(rule 1) = {lparenT}
- Select(rule 2) = {addT}
- select(rule 3) = {mulT}
- select(rule 4) = First(\<Int>\<Ints>)
				 = First(<\int>)
				 = {lparenT, intT}
- select(rule 5) = follow(\<ints>)
				 = {rparenT}
- select(rule 6) = {lparenT}

In the sets coming from rules for the same variable, Select for those rules has no tokens in common (they are disjoint). This makes it an LL 1 grammar.

Parsing &rarr; continue until no more variables. Look at the leftmost variable A and the next token alpha. If alpha is in select(A &rarr; alpha), then use this rule to expand A. If there is no such alpha.

## What obvious but usefule things could stop a grammar from being LL(1)

1. A &rarr; a | ab
2. A &rarr; Aa

**LOOKUP WHAT LEFT ASSOCIATIVE AND RIGHT ASSOCIATIVE OPERATIONS**

## Bottom-Up Parsing

Start with the input string. Apply productions in reverse, until we get back to S. This process gives a right most derivation in reverse.

Scan the input; keep track of what you've seen. Look ahead 1 symbol occasionally and say "Aha! I can use a rule!".

LR(1) Grammar &rarr; a grammar that lets you do this &uarr;

## Some Properties of LR(1) Grammars and Bottom Up Parsers

- If LL works, so does LR
- Virtually all programming languages are LR(1)
- LR(1) : Not ambiguous languages

- LR most general grammar that can be parsed without back tracking
- Can be built efficiently; good at detecting errors
- Super hard to built by hand

## Concrete Syntax Tree &rarr; Abstract Syntax

eg (+ 2 3 4)
