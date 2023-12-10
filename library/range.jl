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
