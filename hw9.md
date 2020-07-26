
## Problem 1
a. `"([^\\]|\\[nrt"\\])*"`
b. hw9-02.jpg
c. 
\<expr> &rarr; \<expr> concaT \<term> | \<term>
\<op> &rarr; intT colT intT | intT
\<term> &rarr; lparenT \<expr> rparenT | \<expr> lbracT \<op> rbracT | quoteT stringT quoteT
c & d: hw9-03.jpg + hw9-04.jpg

## Problem 2
hw9-01.jpg

## Problem 3
a. `(00)*1(11)*`
b. `(0|2|(12))*`
c. `0(0|1)*0`: strings that starts and ends with 0's and can have alternate between 0's and 1's in the middle.
d.`(1|2|0(0|1)*2)*` = `(1 or 2 or 00*2 or 01*2)*`: strings that consists of a starting 0 will follow by multiple 0's or 1's and end with a 2.

if starts with 0, can entirely end with a numbers of 1 or entirely end with a numbers of 2
if starts with 1, can either end with a 0, 1, or 2, and the middle part consists of 0 or 0 that accompanyng with either 1 or 2.

## Problem 4
Parsing tree: hw9-02.jpg
__a. Left most derivation:__
S
&rarr; (D)Q 
&rarr; idT assignT (E) scT Q 
&rarr; idT assignT (G) F scT Q 
&rarr; idT assignT intT (F) scT Q 
&rarr; idT assignT intT addT (E) scT Q 
&rarr; idT assignT intT addT (G) F scT Q
&rarr; idT assignT intT addT intT (F) scT Q 
&rarr; idT assignT intT addT intT epsilon scT (Q)
&rarr; idT assignT intT addT intT epsilon scT ((D) Q)
&rarr; idT assignT intT addT intT epsilon scT (idT assignT (E) scT Q)
&rarr; idT assignT intT addT intT epsilon scT (idT assignT funcT idT dotT (E) scT Q)
&rarr; idT assignT intT addT intT epsilon scT (idT assignT funcT idT dotT (G) F scT Q)
&rarr; idT assignT intT addT intT epsilon scT (idT assignT funcT idT dotT idT (F) scT) Q
&rarr; idT assignT intT addT intT epsilon scT (idT assignT funcT idT dotT idT epsilon scT (Q))
&rarr; idT assignT intT addT intT epsilon scT idT assignT funcT idT dotT idT epsilon scT epsilon

__b. Right most derivation:__
S
&rarr; D(Q)
&rarr; DD(Q)
&rarr; D(D)epsilon
&rarr; D idT assignT (E) scT epsilon
&rarr; D idT assignT funcT idT dotT (E) scT epsilon
&rarr; D idT assignT funcT idT dotT G (F) scT epsilon
&rarr; D idT assignT funcT idT dotT (G) epsilon scT epsilon
&rarr; (D) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; (idT assignT (E) scT) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; (idT assignT G (F) scT) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; (idT assignT G addT (E) scT) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; (idT assignT G addT G (F) scT) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; (idT assignT G addT (G) epsilon scT) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; (idT assignT (G) addT intT epsilon scT) idT assignT funcT idT dotT idT epsilon scT epsilon
&rarr; idT assignT intT addT intT epsilon scT idT assignT funcT idT dotT idT epsilon scT epsilon

__c. First & Follow Rule__
First(S) = {idT}
First(Q) = {idT, epsilon}
First(D) = {idT}
First(E) = {idT, ifT, funcT, lbrackT, intT, lparenT}
First(F) = {addT, epsilon}
First(G) = {idT, intT, lparenT}

Follow(S) = {$}
Follow(Q) = {$}
Follow(D) = {idT}

Follow(E) 
= follow(F) U {scT, thenT, elseT, rbrackT, rparenT} U first(E) U follow(G) (since F can be epsilon) 
= {scT, thenT, elseT, rbrackT, rparenT, addT, idT, ifT, funcT, lbrackT, intT, lparenT}

Follow(F) = Follow(E) = {scT, thenT, elseT, rbrackT, rparenT, idT, ifT, funcT, lbrackT, intT, lparenT}

Follow(G) = First(F) = {addT} 

__d. LL(1) Parsing__
S. 
select(rule1) = First(D) = {idT}

Q. 
select(rule2) = First(D) = {idT}
select(rule3: Q &rarr; epsilon) = First(epsilon) U Follow(Q) = {epsilon, $}

D.
select(rule4) = {idT}

E.
select(rule5: E &rarr; GF) = First(G) = {idT, intT, lparenT}
select(rule6) = {ifT}
select(rule7) = {funcT}
select(rule8) = {lbrackT}

F. 
select(rule9) = {addT}
select(rule10) = First(epsilon) U Follow(F) = {epsilon, scT, thenT, elseT, rbrackT, rparenT, idT, ifT, funcT, lbrackT, intT, lparenT}

G.
select(rule11) = {idT}
select(rule12) = {intT}
select(rule13) = {lparenT}


Since each variable have different select sets, the language is LL(1) parsing. 
