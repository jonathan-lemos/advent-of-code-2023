include("common.jl")

input_lines = aoclines("16")


function debug_print_seen(tiles_seen)
    for i in eachindex(input_lines)
        for j in eachindex(input_lines[1])
            if (i, j) in tiles_seen
                print('#')
            else
                print(input_lines[i][j])
            end
        end
        pln()
    end
end


function part1()
    beams = Queue{Any}()
    seen = Set()

    tiles_seen = Set()

    function push_beam(x, y, dir)
        if (x, y, dir) in seen
            return
        end

        if !(1 <= x <= length(input_lines)) || !(1 <= y <= length(input_lines[1]))
            return
        end

        enqueue!(beams, (x, y, dir))
        push!(seen, (x, y, dir))
        push!(tiles_seen, (x, y))
    end

    push_beam(1, 1, (0, 1))

    while length(beams) > 0
        x, y, dir = dequeue!(beams)
        c = input_lines[x][y]

        if c == '.'
            x += dir[1]
            y += dir[2]
            push_beam(x, y, dir)
        elseif c == '\\'
            dir = Dict(
                (1, 0) => (0, 1),
                (0, -1) => (-1, 0),
                (0, 1) => (1, 0),
                (-1, 0) => (0, -1)
            )[dir]
            x += dir[1]
            y += dir[2]
            push_beam(x, y, dir)
        elseif c == '/'
            dir = Dict(
                (1, 0) => (0, -1),
                (0, 1) => (-1, 0),
                (-1, 0) => (0, 1),
                (0, -1) => (1, 0)
            )[dir]
            x += dir[1]
            y += dir[2]
            push_beam(x, y, dir)
        elseif c == '|'
            if dir[2] == 0
                x += dir[1]
                y += dir[2]
                push_beam(x, y, dir)
            else
                x1 = x + 1
                x2 = x - 1
                push_beam(x1, y, (1, 0))
                push_beam(x2, y, (-1, 0))
            end
        elseif c == '-'
            if dir[1] == 0
                x += dir[1]
                y += dir[2]
                push_beam(x, y, dir)
            else
                y1 = y + 1
                y2 = y - 1
                push_beam(x, y1, (0, 1))
                push_beam(x, y2, (0, -1))
            end
        end
    end

    debug_print_seen(tiles_seen)
    pln(length(tiles_seen))
end

function part2()
    beams = Queue{Any}()
    seen = Set()

    tiles_seen = DefaultDict(() -> Set{Any}())

    function push_beam(x, y, dir, origin)
        if (x, y, dir, origin) in seen
            return
        end

        if !(1 <= x <= length(input_lines)) || !(1 <= y <= length(input_lines[1]))
            return
        end

        enqueue!(beams, (x, y, dir, origin))
        push!(seen, (x, y, dir, origin))
        push!(tiles_seen[origin], (x, y))
    end

    for i in eachindex(input_lines)
        push_beam(i, 1, (0, 1), (i, 1, (0, 1)))
        push_beam(i, length(input_lines[1]), (0, -1), (i, length(input_lines[1]), (0, -1)))
    end

    for i in eachindex(input_lines[1])
        push_beam(1, i, (1, 0), (1, i, (1, 0)))
        push_beam(length(input_lines), i, (-1, 0), (length(input_lines), i, (-1, 0)))
    end

    while length(beams) > 0
        x, y, dir, origin = dequeue!(beams)
        c = input_lines[x][y]

        if c == '.'
            x += dir[1]
            y += dir[2]
            push_beam(x, y, dir, origin)
        elseif c == '\\'
            dir = Dict(
                (1, 0) => (0, 1),
                (0, -1) => (-1, 0),
                (0, 1) => (1, 0),
                (-1, 0) => (0, -1)
            )[dir]
            x += dir[1]
            y += dir[2]
            push_beam(x, y, dir, origin)
        elseif c == '/'
            dir = Dict(
                (1, 0) => (0, -1),
                (0, 1) => (-1, 0),
                (-1, 0) => (0, 1),
                (0, -1) => (1, 0)
            )[dir]
            x += dir[1]
            y += dir[2]
            push_beam(x, y, dir, origin)
        elseif c == '|'
            if dir[2] == 0
                x += dir[1]
                y += dir[2]
                push_beam(x, y, dir, origin)
            else
                x1 = x + 1
                x2 = x - 1
                push_beam(x1, y, (1, 0), origin)
                push_beam(x2, y, (-1, 0), origin)
            end
        elseif c == '-'
            if dir[1] == 0
                x += dir[1]
                y += dir[2]
                push_beam(x, y, dir, origin)
            else
                y1 = y + 1
                y2 = y - 1
                push_beam(x, y1, (0, 1), origin)
                push_beam(x, y2, (0, -1), origin)
            end
        end
    end

    best_key, best_value = reduce((a, c) -> if length(a[2]) > length(c[2]) a else c end, tiles_seen)
    pln(best_key)
    debug_print_seen(best_value)

    pln(length(best_value))
end

part2()
