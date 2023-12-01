from common import *

ip = aoc_input("1")
ls = lines(ip)

def part1():
    ints = [[int(c) for c in l if c.isdigit()] for l in ls]
    print(sum(i[0] * 10 + i[-1] for i in ints))

def part2():
    import re
    textdigits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    rmap = {x: i + 1 for i, x in enumerate(textdigits)}

    acc = 0
    for l in ls:
        start = re.match("^.*?(one|two|three|four|five|six|seven|eight|nine|\d).*$", l)[1]
        end = re.match("^.*(one|two|three|four|five|six|seven|eight|nine|\d).*?$", l)[1]

        if start in rmap:
            start = rmap[start]
        else:
            start = int(start)

        if end in rmap:
            end = rmap[end]
        else:
            end = int(end)

        acc += start * 10 + end

    print(acc)

part2()


