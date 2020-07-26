Monday, 12-03-2018
*LL parsing using First/Follow*
[a], [e]

Given production rule A -> (a)
#Define 

	Select (A->[a]) = 
		- First ([a]) if [a] cannot turn into [e]
		- First [a] U Follow(A) if [a] cam turn into [e]

Select(1) 	= {lparenT}
Select(2) 	= {addT}
Select(3) 	= {mulT}
Select{4} 	= First(<Int><Ints>)
		  	= First (<Int>)
		  	= {lparenT, intT}
Select{5}	= Follow(<Ints>)
			= {rparenT}
Select{6}	= {lparenT}
Select{7}	= {intT}

## Notice:
Whenever 2 rules are for the same variable, select of these rules have no tokens in common (disjoint). <-- Definition of LL(1) Grammar

#Parsing:
Continue until no more variables
- Look at left most variable A and the next token a
- If a is in Select (A-->[a]), use this rule to expand A (If LL(1), trees at most are such rule)
- If no such rule exists report "Syntax Error"

## What obvious but useful things could stop a grammar from being LL(1)?
- A production rule A --> a|ab
	Simple, useful, breaks LL(1)
- A --> Aa
	let recursion
	Left association operation? you'll have this
	Not LL(1)

#Bottom-up parsing
Start input string
Apply production in reverse, until we get back to S
--> It gives a right most derivation, in reverse

Idea: sca input, keep track of what you've seen look ahead l symbol. Occasionally, relize that we can use a rule.

## LR(1) Grammar
A grammar that lets you do this

## Properties of LR(1) grammars and LR parsing
If LL works, so does LR
Virtually, all programming languages of LR(1)
LR(1): not ambiguous
LR: most general grammars that can be parsed without backtracking
Can be built efficiently 
Good at detecting errors
Really hard to create by hand
--> use a parser generator (yacc- yet another compiler compiler)
Use stacks and states

# Turning concrete Syntax -> abstract syntax
example 1.1 in notebook
e.g. (+ 2 3 4)

Define rules for the production you used to recursively transform into AST 
e.g (2): <Op> --> addT
	replace <Op>--addT with add
	(3): <Int> --> intT
	repladce <Int>--intT with integer is