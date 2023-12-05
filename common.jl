using DataStructures
using Memoization

aocinput(x) = read("inputs/" * x, String)
lines(s) = split(strip(s), "\n")
aoclines = lines ∘ aocinput
int(x) = parse(Int, x)
pln = println
removere(l, re) = replace(l, re => "")
splitstrip(l, o = " ") = map(strip, split(l, o))
splitints(l, o = " ") = map(int, splitstrip(l, o))
