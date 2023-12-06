include("common.jl")

ls = aoclines("6")

times = extractints(ls[1])
distance = extractints(ls[2])

function part1()
  n = 1
  
  for i in 1:length(times)
    ways = 0

    time = times[i]
    dist = distance[i]
    
    for j in 0:dist
      total_dist = (time - j) * j
      if total_dist > dist
        ways += 1 
      end
    end

    pln(ways)
    n *= ways
  end

  pln(n)
end

function part2()
  time = int(join(map(string, times), ""))
  dist = int(join(map(string, distance), ""))

  ways = trunc(Int, (time + sqrt(time^2 - 4 * dist)) / 2) - trunc(Int, (time - sqrt(time^2 - 4 * dist)) / 2)

  pln(ways)
end

part2()
