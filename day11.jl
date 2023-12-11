include("common.jl")

using Base.Iterators
#using Distributed
#@everywhere using DataStructures

ls = aoclines("11")

rowexpanded_ls = collect(Iterators.flatmap(function(n)
    if all([c == '.' for c in n])
        return [n, n]
    else
        return [n]
    end
end, ls))

function colempty(ls, i)
    for c in eachindex(ls)
        if ls[c][i] != '.'
            return false
        end
    end
    return true
end

function colexpand(ls)
    empty_cols = Set([i for i in eachindex(ls[1]) if colempty(ls, i)])

    return collect(map(
        function(r)
            return join(collect(Iterators.flatmap(
                function(j)
                    c = r[j]
                    if j in empty_cols
                        return [c, c]
                    else
                        return [c]
                    end
                end, eachindex(r))))
    end, ls))
end

new_ls = colexpand(rowexpanded_ls)

function gpos()
    ret = Set()

    for (i, r) in enumerate(new_ls)
        for (j, c) in enumerate(r)
            if c == '#'
                push!(ret, (i, j))
            end
        end
    end

    return ret
end

function mdist(a, b)
    c, d = a
    e, f = b

    return abs(c - e) + abs(d - f)
end

function part1()
    gs = collect(gpos())

    r = 0

    for i in eachindex(gs)
        for j in eachindex(gs)
            if j == i
                continue
            end
            r += mdist(gs[i], gs[j])
        end
    end

    pln(r ÷ 2)
end

rowwarp_ls = collect(map(function(n)
    if all([c == '.' for c in n])
        return 'W' ^ length(n)
    else
        return n
    end
end, ls))

function warpcolempty(ls, i)
    for c in eachindex(ls)
        if ls[c][i] != '.' && ls[c][i] != 'W'
            return false
        end
    end
    return true
end

function warpcolexpand(ls)
    empty_cols = Set([i for i in eachindex(ls[1]) if warpcolempty(ls, i)])

    return collect(map(
        function(r)
            return join(collect(map(
                function(j)
                    c = r[j]
                    if j in empty_cols
                        return 'W'
                    else
                        return c
                    end
                end, eachindex(r))))
    end, ls))
end

warp_ls = warpcolexpand(rowwarp_ls)

for row in warp_ls
    pln(row)
end

pln()

function warpgpos()
    ret = Set()

    for (i, r) in enumerate(warp_ls)
        for (j, c) in enumerate(r)
            if c == '#'
                push!(ret, (i, j))
            end
        end
    end

    return ret
end

function part2()
    gs = collect(warpgpos())

#    function warpdist(src, dst)
#        a, b = src
#
#        q = PriorityQueue()
#
#        enqueue!(q, (0, a, b), 0)
#
#        seen = DefaultDict(() -> 0x7FFFFFFFFFFFFFFF)
#        best_dist = 0x7FFFFFFFFFFFFFFF
#
#        seen[(a, b)] = 0
#
#        while length(q) > 0
#            (dist, x, y) = dequeue!(q)
#
#            #pln((dist, x, y))
#
#            if (x, y) == dst
#                #pln((x, y), " is other galaxy at dist ", dist)
#                best_dist = min(dist, best_dist)
#                continue
#            end
#
#            if dist >= best_dist
#                continue
#            end
#
#            for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
#                nx = x + dx
#                ny = y + dy
#
#                if !(1 <= nx <= length(warp_ls)) || !(1 <= ny <= length(warp_ls[1]))
#                    continue
#                end
#
#                if warp_ls[x][y] == 'W' && warp_ls[nx][ny] == 'W'
#                    continue
#                end
#
#                travel_dist = if warp_ls[nx][ny] == 'W' 1000000 else 1 end
#                new_total_dist = dist + travel_dist
#
#                if new_total_dist >= 0x7FFFFFFFFFFFFFFF
#                    pln("EXCEEDED LIMIT")  
#                end
#
#                #pln(travel_dist, " from ", (x, y), " to ", (nx, ny), " total ", new_total_dist)
#
#                if seen[(nx, ny)] <= new_total_dist
#                    continue
#                end
#
#                seen[(nx, ny)] = new_total_dist
#                enqueue!(q, (new_total_dist, nx, ny), new_total_dist)
#            end
#        end
#
#        if best_dist == 0x7FFFFFFFFFFFFFFF
#            pln((src, dst))
#            pln(seen)
#        end
#        @assert best_dist != 0x7FFFFFFFFFFFFFFF
#        return best_dist
#    end
    
    warp_rows = Vector()
    for (i, r) in enumerate(warp_ls)
        if r[1] == 'W'
            push!(warp_rows, i)
        end
    end

    warp_cols = Vector()
    for (i, c) in enumerate(warp_ls[1])
        if c == 'W'
            push!(warp_cols, i)
        end
    end
    
    pln(warp_rows)
    pln(warp_cols)

    function warpmdist(a, b)
        c, d = a
        e, f = b

        rrange = if c < e c => e else e => c end
        crange = if d < f d => f else f => d end

        warp_rows_count = count([true for n in warp_rows if rrange[1] <= n <= rrange[2]])
        warp_cols_count = count([true for n in warp_cols if crange[1] <= n <= crange[2]])

        return (abs(c - e) - warp_rows_count) + (abs(d - f) - warp_cols_count) + (warp_rows_count + warp_cols_count) * 1000000
    end

    r = 0

    for i in eachindex(gs)
        for j in eachindex(gs)
            if j == i
                continue
            end
            r += warpmdist(gs[i], gs[j])
        end
    end

    pln(r ÷ 2)
end

part2()

