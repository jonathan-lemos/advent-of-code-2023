include("common.jl")

input_lines = aoclines("15")
pairs = split(input_lines[1], ",")

function part1()
    s = 0
    for pair in pairs
        a = 0
        for c in pair
            a += Int(c)
            a *= 17
            a %= 256
        end
        pln("$pair $a")
        s += a
    end

    pln(s)
end

function hash(s)
    a = 0
    for c in s
        a += Int(c)
        a *= 17
        a %= 256
    end
    return a
end

function part2()
    boxes = Dict()
    for i in 0:255
        boxes[i] = []
    end

    function hm_push(k, v)
        h = hash(k)

        for (i, (ek, ev)) in enumerate(boxes[h])
            if ek == k
                boxes[h][i] = (k, v)
                return
            end
        end

        push!(boxes[h], (k, v))
    end

    function hm_pop(k, v)
        h = hash(k)

        for (i, (ek, ev)) in enumerate(boxes[h])
            if ek == k
                deleteat!(boxes[h], i)
                return
            end
        end
    end

    for s in pairs
        if isnothing(findfirst('=', s))
            k, v = s[1:end-1], nothing
            hm_pop(k, v)
        else
            k, v = split(s, "=")
            v = int(v)
            hm_push(k, v)
        end
    end

    r = 0

    for (i, box) in boxes
        for (j, (k, v)) in enumerate(box)
            pln("LOOP $i $j $v ", (i + 1) * j * v)
            r += (i + 1) * j * v
        end
    end

    pln(r)
end

part2()
