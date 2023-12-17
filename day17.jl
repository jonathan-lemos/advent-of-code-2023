include("common.jl")

input_lines = aoclines("17")

function part1()
    q = PriorityQueue()
    seen = Dict()

    function pushq(x, y, dir, consec, old_heatloss)
        if !(1 <= x <= length(input_lines)) || !(1 <= y <= length(input_lines[1]))
            return
        end
        if consec > 3
            return
        end
        heatloss = old_heatloss + int(input_lines[x][y])
        if (x, y, dir, consec) in keys(seen) && seen[(x, y, dir, consec)] <= heatloss
            return
        end
        enqueue!(q, (x, y, dir, consec, heatloss), heatloss)
        seen[(x, y, dir, consec)] = heatloss
    end

    pushq(1, 1, (0, 0), 0, 0)

    best_heatloss = 0x7FFFFFFFFFFFFFFF

    while length(q) > 0
        x, y, dir, consec, heatloss = dequeue!(q)

        if (x, y) == (length(input_lines), length(input_lines[1]))
            best_heatloss = min(best_heatloss, heatloss)
            continue
        end

        if heatloss >= best_heatloss
            continue
        end

        odx, ody = dir

        for delta in [(-1, 0), (1, 0), (0, 1), (0, -1)]
            dx, dy = delta

            if odx + dx == 0 && ody + dy == 0
                continue
            end

            if (dx, dy) == dir
                new_consec = consec + 1
            else
                new_consec = 1
            end

            pushq(x + dx, y + dy, (dx, dy), new_consec, heatloss)
        end
    end

    @assert best_heatloss != 0x7FFFFFFFFFFFFFFF
    pln(best_heatloss - int(input_lines[1][1]))
end

function part2()
    q = PriorityQueue()
    seen = Dict()

    function pushq(x, y, dir, consec, old_heatloss)
        if !(1 <= x <= length(input_lines)) || !(1 <= y <= length(input_lines[1]))
            return
        end
        if consec > 10
            return
        end
        heatloss = old_heatloss + int(input_lines[x][y])
        if (x, y, dir, consec) in keys(seen) && seen[(x, y, dir, consec)] <= heatloss
            return
        end
        enqueue!(q, (x, y, dir, consec, heatloss), heatloss)
        seen[(x, y, dir, consec)] = heatloss
    end

    pushq(1, 1, (0, 1), 0, 0)
    pushq(1, 1, (1, 0), 0, 0)

    best_heatloss = 0x7FFFFFFFFFFFFFFF

    while length(q) > 0
        x, y, dir, consec, heatloss = dequeue!(q)

        if (x, y) == (length(input_lines), length(input_lines[1]))
            best_heatloss = min(best_heatloss, heatloss)
            continue
        end

        if heatloss >= best_heatloss
            continue
        end

        odx, ody = dir

        for delta in [(-1, 0), (1, 0), (0, 1), (0, -1)]
            dx, dy = delta

            if odx + dx == 0 && ody + dy == 0
                continue
            end

            if consec < 4 && (dx, dy) != (odx, ody)
                continue
            end

            if (dx, dy) == dir
                new_consec = consec + 1
            else
                new_consec = 1
            end

            pushq(x + dx, y + dy, (dx, dy), new_consec, heatloss)
        end
    end

    @assert best_heatloss != 0x7FFFFFFFFFFFFFFF
    pln(best_heatloss - int(input_lines[1][1]))
end

part2()
