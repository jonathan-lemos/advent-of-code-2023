import DataStructures.DefaultDict

aocinput(x) = read("inputs/" * x, String)
lines(s) = split(strip(s), "\n")
aoclines = lines ∘ aocinput
int(x) = parse(Int, x)
pln = println