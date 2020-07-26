Thanh Nguyen
CS222 - Homework 8
Professor Fox
Monday, November 19, 2018

# Question 1:
## a
loop invariant: val is sum of first i positive-integers
function: first_n_sum that inputs n and ouputs the sum of first n positive integers

## b
loop invariant: val has the value of the maximum element of the list from L[0] to L[i]
funtion: max_element that inputs a non-negative list L and outputs either the greatest element found in L or if L is empty, outputs -1.

## c
loop invariant: L is a list of square of first (i+1)/2 odd integers

# Question 2: 
h8p2_contracts.rkt

# Question 3:
h8p3_proof.py

# Question 4:
## Could the precondition have been easily and usefully stated using assert?  Why or why not?
Yes, because the precondition has properties that are straightforward and can easily be checked with one or two assertion statements: n is an int, and n > 0

## Could the postcondition have been easily and usefully stated using assert?  Why or why not?
No because the assertion statement check properties that have dependencies, specifically n and "first n perfect squares" require computations that aren't straightforward and vary depends on inputs.

# Question 5:
## b
Assertion before expr1: P' and B, P'' and B, P''' and B, etc.
Assertion before expr2: P' and not B, P'' and not B, P''' and not B, etc.

### c
#### Q1:
{P'} and {B} expr2 {Q1} is true
{P''} and {B} expr2 {Q1} is true
{P'''} and {B} expr2 {Q1} is true

#### Q2:
{P'} and not {B} expr2 {Q2} is true
{P''} and not {B} expr2 {Q2} is true
{P'''} and not {B} expr2 {Q2} is true

### d
{P} and {B} expr1 {Q}
{P} and not {B} expr2 {Q}