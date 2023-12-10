using DataStructures
using Memoization

include("library/range.jl")

aocinput(x) = read("inputs/" * x, String)
lines(s) = split(strip(s), "\n")
aoclines = lines ∘ aocinput
int(x) = parse(Int, x)
pln = println
removere(l, re) = replace(l, re => "")
splitstrip(l, o = " ") = map(strip, split(l, o))
splitints(l, o = " ") = map(int, splitstrip(l, o))
extractints(s) = map(int, filter(x -> x != "", split(s, r"[^\-0-9]")))
with_stack(f, n) = fetch(schedule(Task(f,n)))
