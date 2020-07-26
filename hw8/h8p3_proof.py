#Python function to add up first n positive perfect squares.
#A perfect square is an integer times itself.
#The first few positive perfect squares are 1, 4, 9, 16, 25, ...
def sum_first_n_squares(n):

    #Precondition
    #{n is an integer and n > 0}

    # {0 is the sum of the first 0 perfect squares}
    total = 0
    # Assignment rule
    # {total is the sum of the first 0 perfect square number}

    # {1 is the first positive integer number and 1 <= n}
    i = 1
    # {i is the first positive integer and 1 <= n}


    # Loop invariant: total is the sum of first (i-1) perfect squares and i<=n+1
    while i != n + 1:
        # {total is the sum of first (i-1) perfect squares
        # and i <= n and i!= n+1
        i_squared = i * i
        # {i_squared is the i'th perfect squares
        # and total is the sum of first (i-1) perfect squares
        
        total = total + i_squared
        # i_squared is the ith perfect square 
        # and total is the sum of first (i-1) perfect squares and ith perfect squares
        # and total is sum of the first (i-1+1)=i's perfect squares}

        i = i + 1
        # total is the sum of first (i-1) perfect squares and i <= n
    
    # total is the sum of first (i-1) perfect squares and i>=n+1

    #Postcondition
    #{total is the sum of the first n perfect squares}
    
    return total
