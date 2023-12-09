include("common.jl")

ls = aoclines("9")
is = [extractints(l) for l in ls]

function diff(xs)
  r = Vector()

  for i in 2:length(xs)
    push!(r, xs[i] - xs[i - 1])
  end

  return r
end

function pyramid(xs)
  xss = Vector()
  push!(xss, xs)

  while !(all(x -> x == 0, xss[end]))
    push!(xss, diff(xss[end]))
  end

  return xss
end

function extrapolate(pyr)
  push!(pyr[end], 0)

  for i in length(pyr)-1:-1:1
    append!(pyr[i], pyr[i + 1][end] + pyr[i][end])
  end

  return pyr
end

function part1()
  r = 0
  for xs in is
    pyr = extrapolate(pyramid(xs))
    r += pyr[1][end]
    pln(pyr)
  end

  pln(r)
end

function extrapolate_back(pyr)
  r = Vector()

  push!(r, 0)

  for i in length(pyr)-1:-1:1
    append!(r, pyr[i][1] - r[end])
  end

  return r
end


function part2()
  r = 0
  for xs in is
    ns = extrapolate_back(pyramid(xs))
    pln(ns)
    r += ns[end]
  end

  pln(r)
end

part2()
