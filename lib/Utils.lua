local U = {}

function U.colour(r, g, b, a)
    return {r, g or r, b or r, a or 255}
end

function U.grey(level, a)
    return {level, level, level, a or 255}
end

-- Point should be a table { x, y }, rect should be a table { x, y, w, h }
function U.point_in_rectangle(point, rect)
    return not(
        point.x > rect.x + rect.width or
        point.x < rect.x or
        point.y > rect.y + rect.height or
        point.y < rect.y
    )
end

function U.mouse_in_bounds(self, mx ,my) 
    return mx >= self.pos.x - self.width / 2 and mx <= self.pos.x + self.width / 2 and
           my >= self.pos.y - self.height / 2 and my <= self.pos.y + self.height / 2
end

return U