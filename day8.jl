include("common.jl")

ls = aoclines("8e3")

instruction = ls[1]

adj = Dict()

for mapping in ls[3:end]
  from, _, left_to, right_to = split(mapping)
  left_to = strip(left_to, ['(', ',', ')'])
  right_to = strip(right_to, ['(', ',', ')'])

  adj[from] = (left_to, right_to)
end

function part1()
  i = 0
  node = "AAA"
  moves = 0
  while node != "ZZZ"
    pln(node)

    moves += 1

    dir = instruction[i+1]
    idx = if dir == 'R'
      2
    else
      1
    end

    pln(dir, adj[node])

    node = adj[node][idx]

    i = (i + 1) % length(instruction)
  end

  pln(moves)
end

function part2()
  function cycle(start)
    path = Vector()
    seen = Set()

    node = start
    i = 0

    while true
      dir = instruction[i+1]
      idx = if dir == 'R'
        2
      else
        1
      end

      tup = (node, i)
      push!(path, tup)
      if tup in seen
        return path
      end

      push!(seen, tup)

      node = adj[node][idx]
      i = (i + 1) % length(instruction)
    end
  end

  function process_cycle(c)
    cycle_entry = 0

    for (i, e) in enumerate(c)
      if e == c[end]
        cycle_entry = i
        break
      end
    end

    cycle_length = length(c) - cycle_entry
    front_length = length(c) - cycle_length - 1

    zs = Vector()
    for i in cycle_entry:length(c)-1
      if c[i][1][end] == 'Z'
        push!(zs, i - cycle_entry + 1)
      end
    end

    return (cycle_length, front_length, zs)
  end

  cycles = [process_cycle(cycle(s)) for s in keys(adj) if s[end] == 'A']

  for cycle in cycles
    cycle_length, front_length, zs = cycle

    for z in zs
      starter = front_length + (z - 1)
      divisor = starter ÷ cycle_length
      modulus = starter % cycle_length

      pln("x % $cycle_length == $modulus, x >= $divisor")
    end

    pln("AND")
  end

  # i looked at the above result and noticed the modulus was 0 for all of them
  # so i just lcm'd the cycle lengths
  # the below code took too long
  return

  ct = DefaultDict(0)
  i = 0
  best = 0xFFFFFFFFFFFFFFFF
  while true
    flag = false

    for cycle in cycles
      cycle_length, front_length, zs = cycle

      for z in zs
        v = cycle_length * i + front_length + (z - 1)
        if v < best
          flag = true
        end
        ct[v] += 1
        if ct[v] == length(cycles)
          best = min(best, v)
        end
      end
    end

    if !flag
      break
    end

    i += 1
  end

  pln(best)

end

part2()
