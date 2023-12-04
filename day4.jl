include("common.jl")

ls = aoclines("4")

function parseline(l)
  l = replace(l, r"Card\s+\d+: " => "")
  l, r = split(l, "|")

  l = strip(l)
  r = strip(r)

  l = map(int, split(l))
  r = map(int, split(r))

  return (l, r)
end

ls = map(parseline, ls)

function part1()
  acc = 0
  for (l, r) in ls
    v = length(intersect(Set(l), Set(r)))
    if v > 0
      acc += 2^(v-1) 
    end
  end
  pln(acc)
end


function part2()
  nct = DefaultDict(0)

  for (i, (l, r)) in enumerate(ls)
    nct[i] += 1
    v = length(intersect(Set(l), Set(r)))
    if v > 0
      for j in (i+1):(min(i+v, length(ls)))
        nct[j] += nct[i]
      end
    end
    pln(i)
    pln(nct)
  end
  pln(sum(values(nct)))
end

part2()
