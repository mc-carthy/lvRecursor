local U = {}

function U.colour(r, g, b, a)
    return {r, g or r, b or r, a or 255}
end

function U.grey(level, a)
    return {level, level, level, a or 255}
end

return U