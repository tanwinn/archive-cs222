Monday November 12 2018

# Loop invariant 
Def: A loop invariant is an assertion that is true. Before and after every iteration


`def factorial (n):
	val = 1
	i = 0
	while i!=n:
		i+=1
		val\*=i
	return val`

Loop invariant: val is i!


## To prove a loop invariant:
- prove that it holds at start
- prove holds after every iteration

If code is well-written, loop invariant should be some partial solution to problem

`def fib(n):
	last = 1
	two_ago= 0
	i = 1
	while i < n:
		cur = two_ago + last
		two_ago = last
		last = cur
		i+=1
	return last`

Loop invariant: 
1. last is its Fibbonacci number
2. last+two_ago is (i+1)th fib number
3. two_ago is (i-1)th number
4. [1] and i<=n

Recall While Rule:
If 
	{P and B} expr {P} 
is true then 
	{P} while B {P and not {B}} 
is true

Before return last
[...]
#### With 1
...
#### With 4 is the loop invariant:
After loop, we get 
{last is ith fib number and (i<=n and i>=n)=>(i=n)}
---------------------P---------------------  not{B}
=> [last is nth fib]

### Prove partial correctness:


`def factorial (n):
	{n is a non-negative integer} <- Pre-cond for whole function
	{1 is 0!} --> true so we can take it here
	val = 1
	{val is 0!} <- assignment rule
	i = 0
	{val is i!}
	{val is ((i+1)-1)!}
	while i!=n:
		{val is (i-1)!}
		i+=1
		{val*i is (i*(i-1))! = i!}
		val\*=i
	{val is i! and i=n}
	{val = n!}
	return val`



1. Go through assignment rule
2. 