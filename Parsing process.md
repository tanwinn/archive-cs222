Friday, November 30, 2018
CS222 - PL
Parsing Process

# Note: ==============
(e): epsilon
(a): alpha
(b): beta
// ==================================

# Parsing process: 
Has 2 approaches
- top down: faster, modify what we'll discuss
- bottom up: more powerful, highly automatable

# Top Don parsing:
Start from S, try to construct a procedure via a leftmost derivation 
At each step, from current sentential form, decide on a production rule to apply to left most variable. 

## Key issues: how to decide?

### Naive approach: 
Recursive descent passing, try a rule, if it works then continue. If not, go back and try different rule. If you run out of rules, and didn't derive string --> Fail

Problems: 
- Inefficient
- Non-terminatig (example 2.1)

### Another approach (smarter):
Modify parser so it can guess the rule it should use
Pro: way more efficient
Con: only works in certain restricted cases (restrictions on the grammar)

### L-L parsing:
left to right, left most

#### "Decide" in L-L paring means:
- Peek at next token
Figures out which rule allows what token to use next
--> or if there's a rule that can make (e), maybe you'll do that, then do all this again on the next token
- If processign a terminal, move to the next token
- Grammar that lets you do this in unique way ar each step (casted) an LL(1) grammar.

#### Example LL(1) grammar (example 2.2):
<Expr> 	--> lparenT <Op><Int><Ints>rparenT
<Op> 	--> addT | mulT
<Ints> 	--> <Int><Ints> | (E)
<Int> 	--> <Expr> | intT

Integer arithmetic in Rackt

##### Expression:
`(+ (* 2 3) 4)`

##### Start:
<Expr>, next token is (
	Use rule 1

(<Op><It><Ints>):
	To get to <Op>, consume (
	next token is +
	use rule 2

(+ <Int><Ints>)
	consumes +
	next token is (
	use rule 6

etc.

##### Implementation:
1. First and Follow sets
(a)  variables or terminal,
Fist (a) = set of terminals that can be the first symbol of something derived from (a)
--> can include (e)

A variable, follow (A) = set of terminals, that can come afer something starting from A
--> can include $ as end of stream

2. Rules (Recursive definition):
Base case:
`
First ([e]) =  {(e)}
First (a) = {a} 		// a terminal
First ([a][b])) = First ((a)) U First ((b)) // Union ... (something)
				if can get (e) from (a)
First ((a)(b)) = First ((a)) if can't get 
First ((a)|(b)) = First ((a)) U First ((b))
`

__Example__:
First ((e)) 	= {(e)}
First (token type) = {itself}
First (<Expr>) 	= {lparenT}
First (<Op>) 	= {addT, mulT}
First (<Ints) 	= {lparenT, intT, (e)}
First (<Int>)	= {lparenT, intT}

3. Rules for Follow:
i. $ is in Follow(s) (study case)
ii. Production: A->(a)B(b)
Everything but (e) in First((b)) goes in Follow(B)
iii. Production: A->(a)B or A ->(a)B(b) with (e) in First((b))
Everything in Follow(A) goes in Follow(B)

__Examle__:
Follow(<Expr>) = {$}
Follow(<Op>) = {lparenT, intT} <--- First(<Int>)(1, 2)
Follow(<Int>) = {lparenT, intT, rparenT} <--- because <Ints> goes to (e)
Follow(<Ints>) = {rparenT}
