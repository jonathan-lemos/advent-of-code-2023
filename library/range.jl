function range_intersects(a, b)
    c, d = a
    e, f = b

    return !(c <= d < e <= f || e <= f < c <= d)
end

function range_intersection(a, b)
    c, d = a
    e, f = b
    
    if c <= d < e <= f || e <= f < c <= d
        return 0 => -1
    end

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

        if from_lo <= from_hi < remove_lo <= remove_hi
            return [remove_from]
        elseif remove_lo <= remove_hi < from_lo <= from_hi
            return [remove_from]
        elseif from_lo <= remove_lo <= remove_hi <= from_hi
            return [from_lo => remove_lo - 1, remove_hi + 1 => from_hi]
        elseif remove_lo <= from_hi <= remove_hi
            return [from_lo => remove_lo - 1]
        elseif remove_lo <= from_lo <= remove_hi
            return [remove_hi + 1 => from_hi]
        else 
            throw("shit's fucked ($from_lo $from_hi) - ($remove_lo $remove_hi)")
        end
    end
    return filter(r -> !range_empty(r), f())
end

function range_union(a, b)
    c, d = a
    e, f = b

    if c > e
        return range_union(b, a)
    end

    if d >= e
        return [c => max(d, f)]
    else
        return [c => d, e => f]
    end
end

in_range(r, x) = range_intersects(r, x => x)

range_len(a) = max(0, a[2] - a[1] + 1)

