local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local abs = math.abs

local R = Class:derive("Rect")

-- x, y Is the top-left corner
function R:new(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
end

-- x, y Is the centre
function R.create_centred(x, y, w, h)
    local r = R(0, 0, w, h)

    r:set_centre(x, y)

    return r
end

function R:centre()
    return Vector2(self.x + self.w / 2, self.y + self.h / 2)
end

function R:set_centre(x, y)
    self.x = x - self.w / 2
    self.y = y - self.h / 2
end

-- Returns the top-left point
function R:min()
    return Vector2(self.x, self.y)
end

-- Returns the lower-right point
function R:max()
    return Vector2(self.x + self.w, self.y + self.h)
end

function R:size()
    return Vector2(self.w, self.h)
end

function R:minkowski_difference(other)
    assert(other:is(R), "other parameter must be a Rect.")
    local top_left = Vector2.subtract(self:min(), other:max())
    local new_size = Vector2.add(self:size(), other:size())
    
    local new_left = Vector2.add(top_left, new_size:divide(2))
 
    return R.create_centred(new_left.x, new_left.y, new_size.x, new_size.y)
end

function R:closest_point_on_bounds(point)
    -- First check x-axis
    local min_dst = abs(point.x - self.x)
    local max = self:max()
    local bounds_point = Vector2(self.x, point.y)

    if abs(max.x - point.x) < min_dst then
        min_dst = abs(max.x - point.x)
        bounds_point = Vector2(max.x, point.y)
    end

    -- Then check y-axis
    if abs(max.y - point.y) < min_dst then
        min_dst = abs(max.y - point.y)
        bounds_point = Vector2(point.x, max.y)
    end
    
    if abs(self.y - point.y) < min_dst then
        min_dst = abs(self.y - point.y)
        bounds_point = Vector2(point.x, self.y)
    end
    
    return bounds_point
end

return R