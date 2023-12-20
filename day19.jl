include("common.jl")

input_lines = aocinput("19")

function parse_rule(r)
    if !occursin(":", r)
        return (nothing, r)
    end

    condition, output = split(r, ":")

    variable, number = split(condition, r"[<>]")

    return ((variable, if occursin(">", condition)
        '>'
    else
        '<'
    end, int(number)), output)
end

function parse_workflow(w)
    name, rest = split(w, "{")

    rules = split(rest[1:end-1], ",")

    return (name, [parse_rule(r) for r in rules])
end

workflow_lines, rating_lines = [lines(x) for x in split(input_lines, "\n\n")]

workflows = Dict()

for w in workflow_lines
    name, rule = parse_workflow(w)
    workflows[name] = rule
end

function parse_part(p)
    variable, rating = split(p, "=")
    return (variable, int(rating))
end

function parse_rating(r)
    parts = split(r[2:end-1], ",")
    ret = Dict()

    for p in parts
        k, v = parse_part(p)
        ret[k] = v
    end

    return ret
end

ratings = [parse_rating(r) for r in rating_lines]

function part1()
    acc = 0

    for rtgdict in ratings
        node = "in"

        while true
            oldnode = node

            if node == "R"
                break
            end

            if node == "A"
                acc += rtgdict["x"] + rtgdict["m"] + rtgdict["a"] + rtgdict["s"]
                break
            end

            wf = workflows[node]

            for (condition, output) in wf
                if isnothing(condition)
                    node = output
                    break
                end

                var, op, value = condition
                if op == '<'
                    op = (a, b) -> a < b
                else
                    op = (a, b) -> a > b
                end
                if op(rtgdict[var], value)
                    node = output
                    break
                end
            end

            @assert node != oldnode
        end
    end

    pln(acc)
end

function part2()
    function range_lt_gte(range, value)
        a, b = range

        return (a => min(b, value - 1), max(value, a) => b)
    end


    function range_lte_gt(range, value)
        a, b = range
        return (a => min(b, value), max(value + 1, a) => b)
    end

    @memoize function acceptcount(node, xrange, mrange, arange, srange)
        lenprod = range_len(xrange) * range_len(mrange) * range_len(arange) * range_len(srange)
        if lenprod == 0
            return 0
        end

        if node == "R"
            return 0
        end

        if node == "A"
            return lenprod
        end

        wf = workflows[node]

        count = 0

        for (condition, output) in wf
            if range_empty(xrange) ||range_empty(mrange) || range_empty(arange) || range_empty(srange)
                break
            end

            if isnothing(condition)
                count += acceptcount(output, xrange, mrange, arange, srange)
                break
            end

            var, op, value = condition

            if var == "x"
                if op == '<'
                    l, r = range_lt_gte(xrange, value)
                    count += acceptcount(output, l, mrange, arange, srange)
                    xrange = r
                else
                    l, r = range_lte_gt(xrange, value)
                    count += acceptcount(output, r, mrange, arange, srange)
                    xrange = l
                end
            elseif var == "m"
                if op == '<'
                    l, r = range_lt_gte(mrange, value)
                    count += acceptcount(output, xrange, l, arange, srange)
                    mrange = r
                else
                    l, r = range_lte_gt(mrange, value)
                    count += acceptcount(output, xrange, r, arange, srange)
                    mrange = l
                end
            elseif var == "a"
                if op == '<'
                    l, r = range_lt_gte(arange, value)
                    count += acceptcount(output, xrange, mrange, l, srange)
                    arange = r
                else
                    l, r = range_lte_gt(arange, value)
                    count += acceptcount(output, xrange, mrange, r, srange)
                    arange = l
                end
            else
                if op == '<'
                    l, r = range_lt_gte(srange, value)
                    count += acceptcount(output, xrange, mrange, arange, l)
                    srange = r
                else
                    l, r = range_lte_gt(srange, value)
                    count += acceptcount(output, xrange, mrange, arange, r)
                    srange = l
                end
            end
        end
        return count
    end

    pln(acceptcount("in", 1=>4000, 1=>4000, 1=>4000, 1=>4000))
end

part2()
