include("common.jl")

input = aocinput("5")
groups = split(input, "\n\n")
groups = [strip(x) for x in groups]

seeds = splitints(removere(groups[1], r"seeds: "))

mapping = DefaultDict(() -> DefaultDict(Vector))

for group in groups[2:end]
  ls = lines(group)
  header = ls[1]
  header = removere(header, r" map:$")
  src, dst = split(header, "-to-")

  for line in ls[2:end]
    dststart, srcstart, count = splitints(line)
    push!(mapping[src][dst], (srcstart, dststart, count))
  end
end

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

function in_range(r, x)
  return range_intersect(r, x => x)
end

function part1()
  best = 0x7FFFFFFFFFFFFFFF

  for seedno in seeds
    q = Vector([(seedno, "seed")])
    seen = Set()
    push!(seen, (seedno, "seed"))
    while length(q) > 0
      nq = Vector()
      for (no, type) in q
        if type == "location"
          best = min(best, no)
        end

        for neighbor in keys(mapping[type])
          hit = false
          for (srcstart, dststart, count) in mapping[type][neighbor]
            if srcstart <= no <= srcstart + count - 1
              hit = true
              delta = no - srcstart
              obj = (dststart + delta, neighbor)
              if !(obj in seen)
                push!(seen, obj)
                push!(nq, obj)
              end
            end
          end
          if !hit
            obj = (no, neighbor)
            if !(obj in seen)
              push!(seen, obj)
              push!(nq, obj)
            end
          end
        end
      end
      q = nq
    end
  end

  pln(best)
end

function part2()
  new_seeds = Vector()
  for i in 1:2:(length(seeds)-1)
    push!(new_seeds, seeds[i] => seeds[i] + seeds[i + 1] - 1)
  end

  best = 0x7FFFFFFFFFFFFFFF

  for (lo, hi) in new_seeds
    q = Vector([(lo => hi, "seed")])
    seen = Set()
    push!(seen, (lo => hi, "seed"))
    while length(q) > 0
      nq = Vector()
      for ((lo, hi), type) in q
        if type == "location"
          best = min(best, lo)
        end

        for neighbor in keys(mapping[type])
          unhit = [lo => hi]

          for (srcstart, dststart, count) in mapping[type][neighbor]
            if range_intersects(lo => hi, srcstart => srcstart + count - 1)
              ilo, ihi = range_intersection(lo => hi, srcstart => srcstart + count - 1)

              i = 1
              while i <= length(unhit)
                unhit_lo, unhit_hi = unhit[i]
                if unhit_lo <= ilo <= ihi <= unhit_hi
                  unhit[i] = unhit_lo => ilo - 1
                  insert!(unhit, i + 1, ihi + 1 => unhit_hi)
                elseif ilo <= unhit_hi
                  unhit[i] = unhit_lo => ilo - 1
                elseif ihi >= ilo
                  unhit[i] = ihi + 1 => unhit_hi
                end
                i += 1
              end

              unhit = filter(r -> r[1] <= r[2], unhit)

              dilo, dihi = ilo - srcstart => ihi - srcstart
              obj = (dststart + dilo => dststart + dihi, neighbor)
              if !(obj in seen)
                push!(seen, obj)
                push!(nq, obj)
              end
            end
          end

          for (unhit_lo, unhit_hi) in unhit
            obj = (unhit_lo => unhit_hi, neighbor)
            if !(obj in seen)
              push!(seen, obj)
              push!(nq, obj)
            end
          end
        end
      end
      q = nq
    end
  end

  pln(best)
end

part2()
