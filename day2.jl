include("common.jl")

ls = aoclines("2")

function parseline(l)
  l = replace(l, r"Game \d+: " => "")
  xs = split(l, "; ")

  function parsegame(g)
    es = split(g, ", ")
    r = Dict()
    for x in es
      spl = split(x, " ")
      r[spl[2]] = int(spl[1])
    end
    return r
  end

  return [parsegame(x) for x in xs]
end

gs = [parseline(l) for l in ls]

function part1()
  ct = 0

  for (i, g) in enumerate(gs)
    result = DefaultDict(0)
    for d in g
      for (k, v) in d
        result[k] = max(result[k], v)
      end
    end

    pln(result)

    if result["red"] <= 12 && result["green"] <= 13 && result["blue"] <= 14
      ct += i
    end
  end

  pln(ct)
end

function part2()
  p = 0

  for (i, g) in enumerate(gs)
    result = DefaultDict(0)
    for d in g
      for (k, v) in d
        result[k] = max(result[k], v)
      end
    end

    pln(result)
    p += result["red"] * result["green"] * result["blue"]
  end

  pln(p)
end

part2()
