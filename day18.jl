include("common.jl")

input_lines = aoclines("18")

dirs = [splitstrip(l, " ") for l in input_lines]

dirmap = Dict(
    "R" => (0, 1),
    "D" => (1, 0),
    "U" => (-1, 0),
    "L" => (0, -1)
)

function part1()
    colors = Dict()

    x = 1
    y = 1

    colors[(1, 1)] = "#ffffff"

    instrs = [
        ("R", 46, "x"),
        ("D", 6, "x"),
        ("R", 35, "x"),
        ("D", 86, "x"),
        ("R", 37, "x"),
        ("D", 26, "x"),
        ("L", 58, "x"),
        ("U", 83, "x"),
        ("L", 11, "x"),
        ("D", 83, "x"),
        ("L", 49, "x"),
        ("U", 67, "x"),
        ("L", 1, "x"),
        ("U", 50, "x")
    ]

#    instrs = [
#        ("R", 10, "x"),
#        ("D", 15, "x"),
#        ("L", 3, "x"),
#        ("U", 10, "x"),
#        ("L", 4, "x"),
#        ("D", 15, "x"),
#        ("L", 3, "x"),
#        ("U", 20, "x"),
#    ]

    for (d, len, col) in instrs
        col = col[2:end-1]
        d = dirmap[d]

        len = string(len)

        for _ in 1:int(len)
            x += d[1]
            y += d[2]
            colors[(x, y)] = col
        end
    end

    function flood(i, j)
        if (i, j) in keys(colors)
            return
        end

        colors[(i, j)] = "#ffffff"

        for (dx, dy) in [(-1, 0), (1, 0), (0, 1), (0, -1)]
            ni = i + dx
            nj = j + dy

            flood(ni, nj)
        end
    end

    pln(length(colors))

    with_stack(2_000_000_000_00) do
        flood(2, 2)
    end

    pln(length(colors))
end

function part2()
    charmap = ["R", "D", "L", "U"]

    instrs = [(charmap[int(x[3][end-1])+1], parse(Int, x[3][3:end-2], base=16)) for x in dirs]

#    instrs = [
#        ("R", 46),
#        ("D", 6),
#        ("R", 35),
#        ("D", 86),
#        ("R", 37),
#        ("D", 26),
#        ("L", 58),
#        ("U", 83),
#        ("L", 11),
#        ("D", 83),
#        ("L", 49),
#        ("U", 67),
#        ("L", 1),
#        ("U", 50)
#    ]

    #instrs = [(d, int(len)) for (d, len, _) in dirs]
    #pln(instrs)
    #pln()

    row_ranges = DefaultDict(Vector)

    col_ranges = DefaultDict(Vector)

    x = 1
    y = 1

    for (d, len) in instrs
        if d == "R"
            push!(row_ranges[x], y => y + len)
            y += len
        elseif d == "L"
            push!(row_ranges[x], y - len => y)
            y -= len
        elseif d == "D"
            push!(col_ranges[y], x => x + len)
            x += len
        else
            push!(col_ranges[y], x - len => x)
            x -= len
        end
    end

    function merge_ranges(rs)
        rs = [x for x in rs if !range_empty(x)]

        if length(rs) == 0
            return []
        end

        sort!(rs)
        ret = [rs[1]]

        for i in 2:length(rs)
            r = pop!(ret)
            append!(ret, range_union(r, rs[i]))
        end

        return ret
    end

    function range_list_remove(rl, r)
        return merge_ranges(collect(Iterators.flatmap(lr -> range_remove(lr, r), rl)))
    end

    function range_list_intersection(rl, r)
        return merge_ranges(collect(Iterators.flatmap(function (lr)
                result = range_intersection(lr, r)
                if range_empty(result)
                    return []
                end
                return [result]
            end, rl)))
    end

    for k in keys(row_ranges)
        row_ranges[k] = merge_ranges(row_ranges[k])
    end

    unmatched = []
    acc = 0

    mk = 0

    for k in sort(collect(keys(row_ranges)))
        mk = k
        pln("before $k $unmatched")
        pln("matching ", row_ranges[k])

        for rr in row_ranges[k]
            unmatched_new = []

            rr_unmatched = [rr]

            for (h, um) in unmatched
                ix = range_intersection(um, rr)

                if !range_empty(ix)
                    qq = (k - h + 1)
                    qqproduct = qq * range_len(ix)

                    pln("matching rect $ix of height $qq = $qqproduct")

                    acc += range_len(ix) * (k - h + 1)

                    for span in col_ranges[ix[1]]
                        if k == span[1]
                            pln("pushing draggler ", ix[1] => ix[1], " back in")
                            push!(unmatched_new, (k + 1, ix[1] => ix[1]))
                        end
                    end

                    for span in col_ranges[ix[2]]
                        if k == span[1]
                            pln("pushing draggler ", ix[2] => ix[2], " back in")
                            push!(unmatched_new, (k + 1, ix[2] => ix[2]))
                        end
                    end

                end

                rr_unmatched = merge_ranges(Iterators.flatten([range_remove(x, ix) for x in rr_unmatched]))
                append!(unmatched_new, [(h, x) for x in range_remove(um, ix)])
            end

            for rrum in rr_unmatched
                push!(unmatched_new, (k, rrum))
            end

            pln("remove $rr: $unmatched -> $unmatched_new")
            pln("debug rrum: $rr -> $rr_unmatched")
            unmatched = unmatched_new
        end

        pln("after $k $unmatched = $acc")
        pln()
    end

    for (h, s) in unmatched
        pln((h, s), " ", mk)
        acc += range_len(s)
    end

    pln(typeof(acc))

    pln(unmatched)
    pln(acc)

end

function part2_real()
    charmap = ["R", "D", "L", "U"]

    instrs = [(charmap[int(x[3][end-1])+1], parse(Int, x[3][3:end-2], base=16)) for x in dirs]

    #instrs = [("R", 2), ("D", 2), ("L", 2), ("U", 2)]
    #instrs = [("R", 3), ("D", 2), ("L", 2), ("D", 2), ("L", 1), ("U", 5)]

    pln(instrs)

    coords = []

    x = 1
    y = 1

    perimeter = 0
    outer_vertices = 0
    inner_vertices = 0

    for (d, len) in instrs
        push!(coords, (x, y))

        if d == "R"
            y += len
        elseif d == "L"
            y -= len
        elseif d == "D"
            x += len
        else
            x -= len
        end

        perimeter += len
    end

    max_x = reduce((a, c) -> if a[1] > c[1] a else c end, coords)[1]
    max_y = reduce((a, c) -> if a[2] > c[2] a else c end, coords)[2]
    min_x = reduce((a, c) -> if a[1] < c[1] a else c end, coords)[1]
    min_y = reduce((a, c) -> if a[2] < c[2] a else c end, coords)[2]

    center_x = (max_x + min_x) ÷ 2
    center_y = (max_y + min_y) ÷ 2

    function dist(x, y)
        return abs(x - center_x) + abs(y - center_y)
    end

    function point_delta_dir(p1, p2)
        a, b = p1
        c, d = p2

        if a == c
            return (0, (d - b) ÷ abs(d - b))
        else
            return ((c - a) ÷ abs(c - a), 0)
        end
    end

    function corner_convex(i)
        pred_idx = if i == 1 length(coords) else i - 1 end
        succ_idx = if i == length(coords) 1 else i + 1 end
        
        pdx, pdy = point_delta_dir(coords[i], coords[pred_idx])
        sdx, sdy = point_delta_dir(coords[i], coords[succ_idx])

        x, y = coords[i]

        px, py = x + pdx, y + pdy
        sx, sy = x + sdx, y + sdy

        return dist(x, y) >= dist(px, py) && dist(x, y) >= dist(sx, sy)
    end

    for i in eachindex(coords)
        if corner_convex(i)
            outer_vertices += 1
        else
            inner_vertices += 1
        end
    end

    pln(coords)

    r = 0

    for i in 1:length(coords) - 1
        r += coords[i][1] * coords[i + 1][2] - coords[i][2] * coords[i + 1][1]
    end

    r += coords[end][1] * coords[1][2] - coords[end][2] * coords[1][1]

    inner_area = abs(r) ÷ 2
    perimeter_area = perimeter ÷ 2
    vertex_area = (outer_vertices - inner_vertices) ÷ 4

    pln("center: $center_x $center_y")
    pln("inner-outer: $inner_vertices $outer_vertices")
    pln("$inner_area $perimeter_area $vertex_area")
    pln(inner_area + perimeter_area + vertex_area)
end

part2_real()
