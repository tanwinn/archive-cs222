# Finite automata
### Determistic: 
Every state has exactly one rule for every symbol

### Non-determistic: 
States can:
- No rules for a symbol (instantly reject if see that symbol in that state)
- Multiple rules for a symbol (runs all in parallel, accept if any accept)
- E-transitions 
If you get to state 1, spawn a parallel process in state 2.

Examples: 

## Tokenization steps
convert REs to FAs (canonical not best)