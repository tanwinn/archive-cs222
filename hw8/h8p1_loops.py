#a
val = 0
i = 1
while i != n + 1:
    val = val + i
    i = i + 1

# loop invariant: val is sum of first n positive-integer
# function first_n_sum that inputs n and ouputs the sum of first n positive integers

#b
val = -1
i = 0
while i < len(L):
    if val < L[i]:
        val = L[i]
    i = i + 1

# loop invariant: val has the value of the smallest element of the list L or val is -1
# funtion smallest_element that inputs a non-negative list L and outputs either the smallest element found in L or if L is empty, outputs -1.

#c
L = []
i = 1
while True:
    j = i * i
    L.append(j)
    i = i + 2

# loop invariant: 