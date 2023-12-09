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
extractints(s) = map(int, filter(x -> x != "", split(s, r"[^\-0-9]")))

function range_intersects(a, b)
  c, d = a
  e, f = b

  return !(c <= d < e <= f || e <= f < c <= d)
end

function range_intersection(a, b)
  c, d = a
  e, f = b
  _, x, y, _ = sort([c, d, e, f])
  return x => y
end

range_empty(r) = r[1] > r[2]

function range_remove(remove_from, remove_this)
  function f()
    if range_empty(remove_this)
      return [remove_from]
    end

    from_lo, from_hi = remove_from
    remove_lo, remove_hi = remove_this
    if from_lo <= remove_lo <= remove_hi <= from_hi
      return [from_lo => remove_lo - 1, remove_hi + 1 => from_hi]
    elseif remove_lo <= from_hi
      return [from_lo => remove_lo - 1]
    elseif remove_hi >= remove_lo
      return [remove_hi + 1 => from_hi]
    else
      return []
    end
  end
  return filter(r -> !range_empty(r), f())
end

in_range(r, x) = range_intersects(r, x => x)
