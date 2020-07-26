Parsing
Wednesday, November 14

### Def:
Given a  text of a program, translate it into Racket and then quote it

## 3 parts to parsing:
1. Tokenizing: convert the text of  aprogram into a bunch of meaningful pieces
2. Concrete syntax: convert list of tokens into a tree
3. Abstract synteax: Take the tree of tokens and turn it into a useful internal representation

## Abstract syntaxt tre:E

Structural representation of a program that's insependent (not strictly) of a program that's written in (we've seen this)


### 2--->3 eliminates things likes:
- parentheses
- brackets
-obscure syntax tat language might have

#### Example:
Python 
`
def dbl(x):
	return 2*x`
C 
`
`

## Tokenizing:
- Done by a tokenizer (scanner, leer)
- Takes the text of the program and btraks it up into tokens
- Tokens are
	. Lexeme A "word"
	. Token type: A tag associated to a lexeme
- Examples:
	. Lexemes: 10, +, (), 3.79
	. Tokens (has a T at the end represents Toekn types as opposed to data type):
		10 : intT 
		+ : addT
		( : lparenT
		3.79: floatT

### Examples:
Python:
`def dbl (x):
	return 2*x`

#### Note: 
We typical ignore whitespaces and new lines because pl usually have strict structure and conventions, but Python some white spaces == indentations --> \n \t (tab) matter

Tokens: 
	def 	: defT
	dbl 	: idT
	(  		: lparenT
	x  		: idT
	)  		: rparenT
	:  		: colonT
	\n 		: nlT/newlnT
	\t 		: tabT
	return 	: retT
	2  		: intT
	*		: multT
	x		: idT

 
C
`int dbl (int x){
	return 2*x
}`

Tokens:
	int 	: dataT (?) or maybe defT
	dbl 	: idT
	(  		: lparenT
	int 	: dataT
	x  		: idT
	)  		: rparenT
	{ 		: rbracketT
	:  		: colonT
	\n 		: nlT/newlnT
	\t 		: tabT
	return 	: retT
	2  		: intT
	*		: multT
	x		: idT

#### Important property of token types:
Replacing a token with another token of the same type shouldn't change the phrase structure of the program --> doesn' change the AST

## Scanner:
- Figures out where to break lexemes
- Tags them
- Skips comments/whitespaces

## Parser: (step 2 & 3)
-  Use sequence of token types to construct phrase structure (concrete syntax tree first, then AST later)
- Last step in 3: put lexemes back in for token types --> let us do
	. static typechecking
	. evaluation
	. translation

## Grammar / formal languages:
- Formal language: a set of strings
	. Valid string: string in the langugae
	. Invalid string: string not in tjhe language

### Def:
An alphabet is the set of allowable characters that can appea in a given language (language over an alphabet)

Examples:
All strings over alphabet {3} --> {"", 3, 33, 333, ...}
Over {A,b,...z} --> The set of all English words
Alphabet {0,1} --> all strings with an even number of 0's {0, 00, 0110} not {01}