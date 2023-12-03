include("common.jl")

ls = aoclines("3")

function adjsym(i, j)
  for di in [-1, 0, 1]
    for dj in [-1, 0, 1]
      if di == 0 && dj == 0
        continue
      end

      ni = i + di
      nj = j + dj

      if !(1 <= ni <= length(ls)) || !(1 <= nj <= length(ls[i]))
        continue
      end

      if ls[ni][nj] != '.' && !isdigit(ls[ni][nj])
        return true
      end
    end
  end
  return false
end

function part1()
  r = 0

  for (i, l) in enumerate(ls)
    nbuf = 0
    symadj = false
    for (j, c) in enumerate(l)
      if isdigit(c)
        nbuf *= 10
        nbuf += int(c)
        if adjsym(i, j)
          symadj = true
        end
      else
        if symadj
          r += nbuf
        end
        nbuf = 0
        symadj = false
      end
    end
    if nbuf > 0 && symadj
      r += nbuf
    end
  end
  pln(r)
end

function gearadj(i, j)
  for di in [-1, 0, 1]
    for dj in [-1, 0, 1]
      if di == 0 && dj == 0
        continue
      end

      ni = i + di
      nj = j + dj

      if !(1 <= ni <= length(ls)) || !(1 <= nj <= length(ls[i]))
        continue
      end

      if ls[ni][nj] == '*'
        return (true, ni, nj)
      end
    end
  end
  return (false, 0, 0)
end

function part2()
  r = 0

  gc = DefaultDict(Vector)

  for (i, l) in enumerate(ls)
    nbuf = 0
    adjgear = Set()
    for (j, c) in enumerate(l)
      if isdigit(c)
        nbuf *= 10
        nbuf += int(c)

        b, x, y = gearadj(i, j)
        if b
          push!(adjgear, (x, y)) 
        end
      else
        if length(adjgear) > 0
          pln(adjgear)
        end
        for (x, y) in adjgear
          append!(gc[(x, y)], nbuf)
        end
        nbuf = 0
        adjgear = Set()
      end
    end
    if nbuf > 0
      pln(adjgear)
      for (x, y) in adjgear
        append!(gc[(x, y)], nbuf)
      end
    end
  end

  for g in values(gc)
    if length(g) != 2
      continue
    end
    r += reduce((a, c) -> a * c, g)
  end

  pln(r)
end

part2()
