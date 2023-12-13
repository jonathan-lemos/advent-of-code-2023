include("common.jl")

ls = aoclines("12")

function parse_line(l)
    a, b = split(l)
    b = extractints(b)
    return (a, b)
end

springs = collect(map(parse_line, ls))

function debug_answer(s, numbers)
    function verify(a)
        strings = collect(filter(x -> length(x) > 0, split(a, r"\.+")))

        pln("$a $strings")
        if length(strings) != length(numbers)
            return false
        end
        for (string, number) in zip(strings, numbers)
            if length(string) != number
                return false
            end
        end
        return true
    end
    
    function permutations(str)
        qidx = findfirst("?", str)

        if isnothing(qidx)
            return [str]
        end

        qidx = qidx[1]

        prefix = str[1:qidx - 1]
        successors = permutations(str[qidx + 1:end])

        ret = []

        for possibility in ["#", "."]
            for successor in successors
                push!(ret, prefix * possibility * successor)
            end
        end

        return ret
    end

    return sum([1 for str in permutations(s) if verify(str)])
end

function part1()
    r = 0

    for (field, numbers) in springs
        pln("$field $numbers")
        field *= "."

        last_hash = if occursin("#", field) findlast("#", field)[1] else 0 end

        @memoize function ways(field_idx, numbers_idx, acc)
            pln("call $field_idx $numbers_idx $acc")

            if numbers_idx > length(numbers)
                return if field_idx > last_hash
                    pln("hit $field_idx $numbers_idx $acc")
                    1 
                else 0 end
            end

            if field_idx > length(field)
                return 0
            end

            if acc > numbers[numbers_idx]
                return 0
            end

            w = 0

            if field[field_idx] == '#' || field[field_idx] == '?'
                w += ways(field_idx + 1, numbers_idx, acc + 1)
            end

            if field[field_idx] == '.' || field[field_idx] == '?'
                if acc == numbers[numbers_idx]
                    w += ways(field_idx + 1, numbers_idx + 1, 0)
                elseif acc == 0
                    w += ways(field_idx + 1, numbers_idx, 0)
                end 
            end
           
            pln("$field_idx $numbers_idx $acc returning $w")
            return w
        end

        count = ways(1, 1, 0)
        pln(count)
        r += count
    end

    pln(r)
end

function part2()
    r = 0

    for (field, numbers) in springs
        pln("$field $numbers")

        field *= "?"
        field ^= 5
        field = field[1:end-1]
        field *= "."

        numbers = repeat(numbers, 5)

        last_hash = if occursin("#", field) findlast("#", field)[1] else 0 end

        @memoize function ways(field_idx, numbers_idx, acc)
            #pln("call $field_idx $numbers_idx $acc")

            if numbers_idx > length(numbers)
                return if field_idx > last_hash
                    #pln("hit $field_idx $numbers_idx $acc")
                    1 
                else 0 end
            end

            if field_idx > length(field)
                return 0
            end

            if acc > numbers[numbers_idx]
                return 0
            end

            w = 0

            if field[field_idx] == '#' || field[field_idx] == '?'
                w += ways(field_idx + 1, numbers_idx, acc + 1)
            end

            if field[field_idx] == '.' || field[field_idx] == '?'
                if acc == numbers[numbers_idx]
                    w += ways(field_idx + 1, numbers_idx + 1, 0)
                elseif acc == 0
                    w += ways(field_idx + 1, numbers_idx, 0)
                end 
            end
           
            #pln("$field_idx $numbers_idx $acc returning $w")
            return w
        end

        count = ways(1, 1, 0)
        pln(count)
        r += count
    end

    pln(r)
end

part2()
