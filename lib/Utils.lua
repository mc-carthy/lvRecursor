local Vector2 = require("lib.Vector2")
local pow = math.pow
local sqrt = math.sqrt

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

function U.mouse_in_rect(mx, my, rx, ry, rw, rh)
    return mx >= rx and mx <= rx + rw and my >= ry and my <= ry + rh
end

function U.AABB_col(rect1, rect2)
    local rect1r = rect1.x + rect1.w
    local rect1b = rect1.y + rect1.h
    local rect2r = rect2.x + rect2.w
    local rect2b = rect2.y + rect2.h

    return rect1r >= rect2.x and rect2r >= rect1.x and
           rect1b >= rect2.y and rect2b >= rect1.y
end

-- Returns true if circles overlap, otherwise false
-- If true, also returns the minimum seperation vector
function U.circle_to_circle_trigger(circle1, circle2)
    local c1_c2 = Vector2(circle1.x - circle2.x, circle1.y - circle2.y)
    local dst = c1_c2:magnitude()

    local overlap = dst < (circle1.r + circle2.r)

    if overlap then
        local unit = Vector2.normalised(c1_c2)
        local msv = Vector2.multiply(unit, circle1.r + circle2.r)
        return true, msv
    else
        return false, nil
    end
end
return U