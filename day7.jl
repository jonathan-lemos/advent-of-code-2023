include("common.jl")

ls = aoclines("7")

cards = "23456789TJQKA"
cards_rmap = Dict(x => i for (i, x) in enumerate(cards))

function hand_rank(hand)
  dd = DefaultDict(0)
  for c in hand
    dd[c] += 1
  end

  counts_sorted = sort(collect(values(dd)), rev=true)

  if counts_sorted[1] == 5
    return 6
  elseif counts_sorted[1] == 4
    return 5
  elseif counts_sorted[1] == 3 && counts_sorted[2] == 2
    return 4
  elseif counts_sorted[1] == 3
    return 3
  elseif counts_sorted[1] == 2 && counts_sorted[2] == 2
    return 2
  elseif counts_sorted[1] == 2
    return 1
  else
    return 0
  end
end

function hand_lt(h1, h2)
  if hand_rank(h1) > hand_rank(h2)
    return false
  end

  if hand_rank(h2) > hand_rank(h1)
    return true
  end

  for (c1, c2) in zip(h1, h2)
    if cards_rmap[c1] > cards_rmap[c2]
      return false
    end
    if cards_rmap[c2] > cards_rmap[c1]
      return true
    end
  end

  return true
end

hands = []
for l in ls
  hand, amt = split(l)
  push!(hands, (hand, int(amt)))
end

function part1()
  sorted_hands = sort(hands, lt = (x, y) -> hand_lt(x[1], y[1]))

  r = 0
  for (i, (h, s)) in enumerate(sorted_hands)
    r += (i * s)
  end

  pln(r)
end

function part2()
  function joker_hand_rank(hand)
    dd = DefaultDict(0)
    for c in hand
      dd[c] += 1
    end

    jks = dd['J']

    counts_sorted = sort([(y, x) for (x, y) in pairs(dd) if x != 'J'], rev=true)
    counts_sorted = [x[1] for x in counts_sorted]

    if length(counts_sorted) == 0
      counts_sorted = [0, 0]
    end
  
    if counts_sorted[1] + jks >= 5
      return 6
    elseif counts_sorted[1] + jks == 4
      return 5
    elseif (3 - counts_sorted[1]) + (2 - counts_sorted[2]) <= jks
      return 4
    elseif counts_sorted[1] + jks == 3
      return 3
    elseif (2 - counts_sorted[1]) + (2 - counts_sorted[2]) <= jks
      return 2
    elseif counts_sorted[1] + jks == 2
      return 1
    else
      return 0
    end
  end

  function joker_hand_lt(h1, h2)
    if joker_hand_rank(h1) > joker_hand_rank(h2)
      return false
    end
  
    if joker_hand_rank(h2) > joker_hand_rank(h1)
      return true
    end

    joker_cards = "J23456789TQKA"
    joker_rmap = Dict((x, i) for (i, x) in enumerate(joker_cards))
  
    for (c1, c2) in zip(h1, h2)
      if joker_rmap[c1] > joker_rmap[c2]
        return false
      end
      if joker_rmap[c2] > joker_rmap[c1]
        return true
      end
    end
  
    return true
  end

  sorted_hands = sort(hands, lt = (x, y) -> joker_hand_lt(x[1], y[1]))

  r = 0
  for (i, (h, s)) in enumerate(sorted_hands)
    r += (i * s)
  end

  pln(r)

end

part2()
