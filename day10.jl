include("common.jl")

ls = aoclines("10e3")

delta_map = Dict(
    '|' => [(-1, 0), (1, 0)],
    '-' => [(0, -1), (0, 1)],
    'L' => [(-1, 0), (0, 1)],
    'J' => [(-1, 0), (0, -1)],
    '7' => [(1, 0), (0, -1)],
    'F' => [(1, 0), (0, 1)],
    '.' => [],
    'S' => [(-1, 0), (1, 0), (0, 1), (0, -1)]
)

pprint_map = Dict(
    '-' => '─',
    '7' => '┐',
    '|' => '│',
    'L' => '└',
    'F' => '┌',
    'J' => '┘',
    '.' => '.',
    'S' => 'S'
)

function getspos()
    for (i, r) in enumerate(ls)
        for (j, c) in enumerate(r)
            if c == 'S'
                return (i, j)
            end
        end
    end
end

function neighbors(i, j)
    c = ls[i][j]

    if c == 'S'
        ns = Vector()
        for (dx, dy) in delta_map['S']
            nx = i + dx
            ny = j + dy

            if !(1 <= nx <= length(ls)) || !(1 <= ny <= length(ls[1]))
                continue
            end

            if (i, j) in neighbors(nx, ny)
                push!(ns, (nx, ny))
            end
        end
        return ns
    else
        return [(i + dx, j + dy) for (dx, dy) in delta_map[c] if (1 <= i + dx <= length(ls)) && (1 <= j + dy <= length(ls[1]))]
    end
end

function part1()
    spos = getspos()

    @memoize function findloop(x, y, prev)
        if (x, y) == spos
            return []
        end

        for (nx, ny) in neighbors(x, y)
            if (nx, ny) == prev
                continue
            end
            fl = findloop(nx, ny, (x, y))
            if !isnothing(fl)
                push!(fl, (x, y))
                return fl
            end
        end
    end

    loop_path = nothing
    (sx, sy) = spos
    for (nx, ny) in neighbors(sx, sy)
        with_stack(2_000_000_000) do
            loop_path = findloop(nx, ny, (sx, sy)) 
        end
        if !isnothing(loop_path)
            push!(loop_path, (sx, sy))
            reverse!(loop_path)
            break
        end
    end

    distances = Dict()

    for (i, element) in enumerate(loop_path)
        distances[element] = min(i - 1, length(loop_path) - i + 1)
    end

    pln(distances)
    pln(reduce((a, c) -> c > a ? c : a, values(distances)))
end

function part2()
    spos = getspos()

    @memoize function findloop(x, y, prev)
        if (x, y) == spos
            return []
        end

        for (nx, ny) in neighbors(x, y)
            if (nx, ny) == prev
                continue
            end
            fl = findloop(nx, ny, (x, y))
            if !isnothing(fl)
                push!(fl, (x, y))
                return fl
            end
        end
    end

    loop_path = nothing
    (sx, sy) = spos
    for (nx, ny) in neighbors(sx, sy)
        with_stack(2_000_000_000) do
            loop_path = findloop(nx, ny, (sx, sy)) 
        end
        if !isnothing(loop_path)
            push!(loop_path, (sx, sy))
            reverse!(loop_path)
            break
        end
    end

    function tup_delta(from, to)
        c, d = to
        a, b = from

        return (d - b, c - a)
    end

    loop_set = Set(loop_path)

    schar = nothing

    for (k, v) in delta_map
        target_set = Set([loop_path[2], loop_path[end]])

        if length(v) != 2
            continue
        end

        (a, b), (c, d) = v
        a += loop_path[1][1]
        c += loop_path[1][1]
        b += loop_path[1][2]
        d += loop_path[1][2]

        if (a, b) in target_set && (c, d) in target_set
            schar = k
            break
        end
    end

    pln(schar)

    seen = Set()

    char_expansion = Dict(
        '|' => [".X.",
                ".X.",
                ".X."],
        '-' => ["...",
                "XXX",
                "..."],
        'L' => [".X.",
                ".XX",
                "..."],
        'J' => [".X.",
                "XX.",
                "..."],
        '7' => ["...",
                "XX.",
                ".X."],
        'F' => ["...",
                ".XX",
                ".X."],
        '.' => ["...",
                "...",
                "..."]
    )

    new_graph = [['?' for _ in 1:length(ls[1])*3] for __ in 1:length(ls)*3]

    for (i, r) in enumerate(ls)
        for (j, c) in enumerate(r)
            i_offset = (i - 1) * 3 
            j_offset = (j - 1) * 3

            if c == 'S'
                c = schar
            elseif !((i, j) in loop_set)
                c = '.'
            end

            ce = char_expansion[c]

            for (k, r2) in enumerate(ce)
                for (l, nc) in enumerate(r2)
                    new_graph[i_offset + k][j_offset + l] = nc
                end
            end
        end
    end

    new_graph = [join(line) for line in new_graph]

    for line in new_graph
        pln(line)
    end

    pln()

    function flood(i, j)
        if !(1 <= i <= length(new_graph)) || !(1 <= j <= length(new_graph[1]))
            return
        end

        if new_graph[i][j] == 'X'
            return
        end

        if (i, j) in seen
            return
        end

        push!(seen, (i, j))

        for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            nx = i + dx
            ny = j + dy

            flood(nx, ny)
        end
    end

    for i in 1:length(new_graph[1])
        with_stack(2_000_000_000) do
            flood(1, i)
            flood(length(new_graph), i)
        end
    end

    for i in 1:length(new_graph)
        with_stack(2_000_000_000) do
            flood(i, 1)
            flood(i, length(new_graph[1]))
        end
    end

    for (i, r) in enumerate(new_graph)
        for (j, c) in enumerate(r)
            if (i, j) in seen
                print('O')
            else
                print("\033[32mI\033[m")
            end
        end
        pln()
    end

    pln()

    count = 0

    inside = Set()

    for (i, r) in enumerate(ls)
        for (j, c) in enumerate(r)
            if (i, j) in loop_set
                continue
            end

            i_offset = (i - 1) * 3 
            j_offset = (j - 1) * 3

            not_filled = false

            for k in 1:3
                for l in 1:3
                    if !((i_offset + k, j_offset + l) in seen)
                        not_filled = true
                        break
                    end
                end
                if not_filled
                    break
                end
            end

            if not_filled
                push!(inside, (i, j))
                count += 1
            end
        end
    end

    for (i, r) in enumerate(ls)
        for (j, c) in enumerate(r)
            if (i, j) in loop_set
                print(c)
            elseif (i, j) in inside
                print("\033[32m$c\033[m")
            else
                print("\033[31m$c\033[m")
            end
        end
        pln()
    end

    pln()
    pln(count)
end

part2()
