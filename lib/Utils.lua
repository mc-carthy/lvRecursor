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

    if overlap then return true else return false end
end

-- Mass_ratio represents circle1.mass / circle2.mass
function U.circle_to_circle_col(circle1, circle2, mass_ratio)

    mass_ratio = mass_ratio or 0
    if mass_ratio < 0 then
        mass_ratio = 0
    elseif mass_ratio > 1 then
        mass_ratio = 1
    end

    local c1_c2 = Vector2(circle1.x - circle2.x, circle1.y - circle2.y)
    local dst = c1_c2:magnitude()
    local overlap = dst < (circle1.r + circle2.r)

    local unit = Vector2.normalised(c1_c2)
    local msv = Vector2.multiply(unit, circle1.r + circle2.r - dst)

    if overlap then
        circle1.x = circle1.x + msv.x * (1 - mass_ratio)
        circle1.y = circle1.y + msv.y * (1 - mass_ratio)
        circle2.x = circle2.x - msv.x * mass_ratio
        circle2.y = circle2.y - msv.y * mass_ratio
        return true
    else 
        return false
    end
end

function U.contains(list, item)
    for val in pairs(list) do
        if val == item then
            return true
        end
    end
    return false
end

function U.index_of(list, item)
    for i, val in ipairs(list) do
        if val == item then
            return i
        end
    end
    return -1
end

-- Returns a given point rotated about the origin
function U.rotate_point(x, y, angle, post_rotation_x_offset, post_rotation_y_offset)
    local x_rot = math.cos(angle) * x - math.sin(angle) * y + post_rotation_x_offset or 0
    local y_rot = math.sin(angle) * x + math.cos(angle) * y + post_rotation_y_offset or 0

    return x_rot, y_rot
end

return U