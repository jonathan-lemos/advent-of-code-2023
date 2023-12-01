def aoc_input(s):
    with open(f"inputs/{s}") as f:
        return f.read()

def lines(s):
    ls = s.split("\n")
    while len(ls) > 0 and ls[-1].strip() == "":
        ls.pop()
    return ls