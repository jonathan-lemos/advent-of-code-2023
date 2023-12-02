include("common.jl")

ls = aoclines("1")

function part1()
  ns = [filter(isdigit, l) for l in ls]
  ss = [int(x[1]) * 10 + int(x[end]) for x in ns]
  pln(sum(ss)) 
end

function part2()
  numbers = split("one two three four five six seven eight nine", " ")
  rmap = Dict(x => i for (i, x) in enumerate(numbers))

  matchtonum(m) = if isdigit(m[1]) int(m) else rmap[m] end
  
  function parseline(l)
    front = match(r"^.*?(one|two|three|four|five|six|seven|eight|nine|\d).*$", l)[1]
    back = match(r"^.*(one|two|three|four|five|six|seven|eight|nine|\d).*?$", l)[1]
    
    return matchtonum(front) * 10 + matchtonum(back)
  end

  pln(sum(parseline(l) for l in ls))
end

part2()
