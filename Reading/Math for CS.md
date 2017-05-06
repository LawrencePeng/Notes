# Math for CS
- K^(p-2) must be the mul-inverse of K (mod p)
- Every linear combination of a and b is a multiple of gcd(a, b) and vice versa.
- Every positive integer n can be written in a unique way as a product of primes:n = p1 ·p2···pj (p1 ≤p2 ≤...≤pj)
- The function φ obeys the following relationships: 
	- 1. If a and b are relatively prime, then φ(ab) = φ(a)φ(b).	2. If p is a prime,then φ(pk) = pk −pk−1 for k≥1.
- Let n be a positive integer. If k is relatively prime to n, then there exists an integer k−1 such that:k·k−1≡1 (modn)
- Suppose n is a positive integer and k is relatively prime to n. Let k1, . . . , kr denote all the integers relatively prime to n in the range 0 ≤ ki < n. Then the sequence:(k1 · k) rem n, (k2 · k) rem n, (k3 · k) rem n, . . . , (kr · k) rem n is a permutation of the sequence:k1, k2, ..., kr
- **Euler’s Theorem**:
	- Suppose n is a positive integer and k is relatively prime to n. Then:kφ(n) ≡ 1 (mod n)

- A graph is bipartite if and only if it contains no odd cycle.
- **Euler’s Formula For every drawing of a connected planar graph v−e+f=2**
- For every drawing of a connected planar graph v−e+f=2
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-03%20at%2011.53.35%20PM.png)
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-03%20at%2011.53.35%20PM%201.png)
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-03%20at%2011.55.16%20PM.png)
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-03%20at%2011.55.58%20PM.png)
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-03%20at%2011.56.44%20PM.png)
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-04%20at%2012.00.39%20AM.png)
- n! ~ sqrt(2 *pi * n) * (n / e)^n
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-04%20at%2012.04.08%20AM.png)
- The solutions to a linear recurrence are defined by the roots of the characteristic equa- tion. Neglecting boundary conditions for the moment:	• If r is a nonrepeated root of the characteristic equation, then r^n is a solution to the recurrence.	• If r is a repeated root with multiplicity k, then		r^n, nr^n, n^2r^n, . . . , n^k−1r^n		are all solutions to the recurrence.
- Let X be a nonnegative random variable. If c > 0, then: Pr(X ≥ c) ≤ Ex(X)/c
- If events E1, . . . En are mutually independent and X is the number of these events that occur, then:
	- Pr(E1 U E2 U … U En) >= 1- e^-Ex(X)
- 
![](Math%20for%20CS/Screen%20Shot%202017-04-04%20at%2012.17.11%20AM.png)
