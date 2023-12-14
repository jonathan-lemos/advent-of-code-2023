include("common.jl")

to_char_vec(s) = collect(map(x -> x, s))

input_lines = aoclines("14")

function shift_rock(ls, i, j, dir)
    @assert ls[i][j] == 'O'
    dx, dy = dir

    while (1 <= i <= length(ls)) && (1 <= j <= length(ls[1])) && (1 <= i + dx <= length(ls)) && (1 <= j + dy <= length(ls[1]))
        ni = i + dx
        nj = j + dy

        if ls[ni][nj] != '.'
            break
        end

        ls[ni][nj] = ls[i][j]
        ls[i][j] = '.'

        i = ni
        j = nj
    end
end

function debug_print_mut_ls(ls)
    str_ls = [join(s) for s in ls]
    for line in str_ls
        pln(line)
    end
end

function col(ls, idx)
    ret = []

    for r in eachindex(ls)
        push!(ret, ls[r][idx])
    end

    return ret
end

function part1()
    ls = collect(map(to_char_vec, input_lines))

    for i in eachindex(ls)
        for j in eachindex(ls[i])
            if ls[i][j] == 'O'
                shift_rock(ls, i, j, (-1, 0))
            end
        end
    end

    @memoize colcount(idx) = sum([length(ls) - i + 1 for (i, c) in enumerate(col(ls, idx)) if c == 'O'])
    sums = [colcount(i) for i in eachindex(ls[1])]
    pln(sums)
    pln(sum(sums))
end

function shift_map(ls, dir)
    if dir[2] == 0
        for i in if dir[1] == 1 reverse(eachindex(ls)) else eachindex(ls) end
            for j in eachindex(ls[i])
                if ls[i][j] == 'O'
                    shift_rock(ls, i, j, dir)
                end
            end
        end
    else
        for j in if dir[2] == 1 reverse(eachindex(ls[1])) else eachindex(ls[1]) end
            for i in eachindex(ls)
                if ls[i][j] == 'O'
                    shift_rock(ls, i, j, dir)
                end
            end
        end
    end
end

function freeze(ls)
    return [join(l) for l in ls]
end

function debug_print_snapshot(ss)
    for l in ss
        pln(l)
    end
end

function part2()
    ls = collect(map(to_char_vec, input_lines))
   
    dirs = [(-1, 0), (0, -1), (1, 0), (0, 1)]

    count = 0
    prev_state = Dict()
    time_skipped = false

    states = []

    function debug_load_sum(ls)
        @memoize colcount(idx) = sum([length(ls) - i + 1 for (i, c) in enumerate(col(ls, idx)) if c == 'O'])
        sums = [colcount(i) for i in eachindex(ls[1])]
        return sum(sums)
    end

    function debug_print_states()
        for (i, ps) in enumerate(states)
            dls = debug_load_sum(ps)
            pln("$i = $dls")
            debug_print_snapshot(ps)
            pln()
        end
    end

    while count < 4000000000
        count += 1

        dir = dirs[(count - 1) % 4 + 1]

        shift_map(ls, dir)

        state = (freeze(ls), (count - 1) % 4 + 1)

        push!(states, state[1])

        if state in keys(prev_state) && !time_skipped
            pln("WARP SKIPPING")

            debug_print_states()

            time_skipped = true

            cycle_delta = count - prev_state[state]
            count_delta = 4000000000 - count

            @assert cycle_delta % 4 == 0

            cycles = count_delta ÷ cycle_delta

            pln("CYCLE_LENGTH = $cycle_delta")

            pln("OLD COUNT = $count")

            count += cycles * cycle_delta

            pln("NEW COUNT = $count")
        else
            prev_state[state] = count
        end
    end

    debug_print_states()
    
    debug_print_mut_ls(ls)

    @memoize colcount(idx) = sum([length(ls) - i + 1 for (i, c) in enumerate(col(ls, idx)) if c == 'O'])
    sums = [colcount(i) for i in eachindex(ls[1])]
    pln(sums)
    pln(sum(sums))
end

part2()

